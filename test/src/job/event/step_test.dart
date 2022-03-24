// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/event/step.dart';
import 'package:batch/src/job/event/task.dart';

void main() {
  test('Test Step with name parameter', () async {
    final step = Step(name: 'Step');
    expect(step.name, 'Step');
    expect(step.precondition, null);
    expect(step.onStarted, null);
    expect(step.onSucceeded, null);
    expect(step.onError, null);
    expect(step.onCompleted, null);
    expect(step.skipPolicy, null);
    expect(step.retryPolicy, null);
    expect(step.hasSkipPolicy, false);
    expect(step.hasRetryPolicy, false);
    expect(await step.shouldLaunch(), true);
    expect(step.hasBranch, false);
  });

  test('Test nextTask', () {
    final step = Step(name: 'Step');
    expect(step.name, 'Step');
    expect(step.tasks.isEmpty, true);

    final task = _Task();
    step.nextTask(task);
    expect(step.tasks.isEmpty, false);
    expect(step.tasks.length, 1);
    expect(step.tasks[0], task);
  });

  test('Test shutdown', () {
    final step = Step(name: 'Step');
    expect(step.name, 'Step');
    expect(step.tasks.isEmpty, true);

    step.shutdown();
    expect(step.tasks.isEmpty, false);
    expect(step.tasks.length, 1);
    expect(step.tasks[0].name, 'ShutdownTask');
  });
}

class _Task extends Task<_Task> {
  @override
  void execute(ExecutionContext context) {}
}
