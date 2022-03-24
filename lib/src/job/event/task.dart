// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/batch_instance.dart';
import 'package:batch/src/batch_status.dart';
import 'package:batch/src/job/config/retry_configuration.dart';
import 'package:batch/src/job/config/skip_configuration.dart';
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/event/event.dart';
import 'package:batch/src/log/logger_provider.dart';

/// This abstract class represents the smallest unit of processing that is
/// included in the steps when a job is executed.
///
/// The processing of each step of the job should be defined by overriding
/// [execute] in a class that inherits from this [Task].
abstract class Task<T extends Task<T>> extends Event<Task> {
  /// Returns the new instance of [Task].
  Task({
    Function(ExecutionContext context)? onStarted,
    Function(ExecutionContext context)? onSucceeded,
    Function(ExecutionContext context, dynamic error, StackTrace stackTrace)?
        onError,
    Function(ExecutionContext context)? onCompleted,
    SkipConfiguration? skipConfig,
    RetryConfiguration? retryConfig,
  }) : super(
          name: T.toString(),
          onStarted: onStarted,
          onSucceeded: onSucceeded,
          onError: onError,
          onCompleted: onCompleted,
          skipConfig: skipConfig,
          retryConfig: retryConfig,
        );

  /// Runs this [Task].
  void execute(final ExecutionContext context);

  /// Shutdown this batch application safely.
  void shutdown() {
    BatchInstance.instance.updateStatus(BatchStatus.shuttingDown);
    warn('The shutdown command was notified by Task: [name=${T.toString()}]');
  }
}
