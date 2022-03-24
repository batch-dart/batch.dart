// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/batch_instance.dart';
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/context/context_support.dart';
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/event/event.dart';
import 'package:batch/src/log/logger_provider.dart' as log;
import 'package:batch/src/runner.dart';

abstract class Launcher<T extends Event<T>> extends ContextSupport<T>
    implements Runner {
  /// Returns the new instance of [Launcher].
  Launcher({
    required ExecutionContext context,
  }) : super(context: context);

  /// The retry count
  int _retryCount = 0;

  Future<bool> executeRecursively({
    required T event,
    required Function(dynamic event) execute,
    bool retry = false,
  }) async {
    if (!retry) {
      await event.onStarted?.call(context);
    }

    super.startNewExecution(name: event.name, retry: retry);

    if (!await event.shouldLaunch()) {
      log.info('Skipped ${event.name} because the precondition is not met.');
      super.finishExecutionAsSkipped(retry: retry);
      return true;
    }

    if (BatchInstance.instance.isShuttingDown) {
      log.info(
          'Skipped ${event.name} because this batch application is shutting down.');
      super.finishExecutionAsSkipped(retry: retry);
      return true;
    }

    try {
      await execute.call(event);
      await event.onSucceeded?.call(context);

      if (BatchInstance.instance.isRunning) {
        if (event.hasBranch) {
          for (final branch in event.branches) {
            if (branch.on == super.branchStatus ||
                branch.on == BranchStatus.completed) {
              await executeRecursively(event: branch.to, execute: execute);
            }
          }
        }
      }

      _retryCount = 0;
      super.finishExecutionAsCompleted(retry: retry);

      return true;
    } catch (error, stackTrace) {
      await event.onError?.call(context, error, stackTrace);

      //! Do not skip and retry if it is an Error.
      //! Only Exception can be skipped and retried.
      if (error is Exception) {
        if (event.hasSkipPolicy && event.skipPolicy!.shouldSkip(error)) {
          log.warn(
            'An exception is detected on Event [name=${event.name}] but processing continues because it can be skipped',
            error,
            stackTrace,
          );

          super.finishExecutionAsSkipped(retry: retry);

          return true;
        } else if (event.hasRetryPolicy &&
            event.retryPolicy!.shouldRetry(error)) {
          if (event.retryPolicy!.isExceeded(_retryCount)) {
            log.error(
              'The maximum number of retry attempts has been reached on Event [name=${event.name}]',
              error,
              stackTrace,
            );

            rethrow;
          }

          log.warn(
            'An exception is detected on Event [name=${event.name}] but processing retries',
            error,
            stackTrace,
          );

          await event.retryPolicy!.wait();
          _retryCount++;

          if (await executeRecursively(
            event: event,
            execute: execute,
            retry: true,
          )) {
            if (!retry) {
              super.finishExecutionAsCompleted(retry: retry);
            }

            return true;
          }
        }

        rethrow;
      }
    } finally {
      if (!retry) {
        await event.onCompleted?.call(context);
      }
    }

    return true;
  }
}
