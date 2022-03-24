// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

// Project imports:
import 'package:batch/src/batch_instance.dart';
import 'package:batch/src/batch_status.dart';
import 'package:batch/src/job/config/retry_configuration.dart';
import 'package:batch/src/job/config/skip_configuration.dart';
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/event/task.dart';
import 'package:batch/src/job/execution.dart';
import 'package:batch/src/log/log_configuration.dart';
import 'package:batch/src/log/logger.dart';

void main() {
  test('Test Task', () async {
    final task = _Task();
    expect(task.name, '_Task');

    final context = ExecutionContext();
    context.jobExecution = Execution(name: 'test', startedAt: DateTime.now());
    expect(() => task.execute(context), returnsNormally);

    expect(task.precondition, null);
    expect(task.onStarted, null);
    expect(task.onSucceeded, null);
    expect(task.onError, null);
    expect(task.onCompleted, null);
    expect(task.skipPolicy, null);
    expect(task.retryPolicy, null);
    expect(task.hasSkipPolicy, false);
    expect(task.hasRetryPolicy, false);
    expect(await task.shouldLaunch(), true);
    expect(task.hasBranch, false);
  });
}

class _Task extends Task<_Task> {
  _Task({
    Function(ExecutionContext context)? onStarted,
    Function(ExecutionContext context)? onSucceeded,
    Function(ExecutionContext context, dynamic error, StackTrace stackTrace)?
        onError,
    Function(ExecutionContext context)? onCompleted,
    SkipConfiguration? skipConfig,
    RetryConfiguration? retryConfig,
  }) : super(
          onStarted: onStarted,
          onSucceeded: onSucceeded,
          onError: onError,
          onCompleted: onCompleted,
          skipConfig: skipConfig,
          retryConfig: retryConfig,
        );

  @override
  void execute(ExecutionContext context) {
    expect(context.jobExecution != null, true);
    expect(context.jobExecution!.name, 'test');

    BatchInstance.instance.updateStatus(BatchStatus.running);
    expect(BatchInstance.instance.isRunning, true);

    //! Required to load to run super.shutdown().
    Logger.loadFrom(config: LogConfiguration(printLog: false));

    expect(() => super.shutdown(), returnsNormally);
    expect(BatchInstance.instance.isRunning, false);
    expect(BatchInstance.instance.isShuttingDown, true);
  }
}
