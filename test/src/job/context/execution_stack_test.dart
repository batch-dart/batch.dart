// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:batch/src/job/context/execution_stack.dart';
import 'package:batch/src/job/event/job.dart';
import 'package:batch/src/job/execution.dart';

void main() {
  test('Test ExecutionStack', () {
    final stack = ExecutionStack();
    expect(stack.isEmpty, true);
    expect(stack.isNotEmpty, false);

    final executions = [
      Execution<Job>(name: 'Test1', startedAt: DateTime.now()),
      Execution<Job>(name: 'Test2', startedAt: DateTime.now()),
      Execution<Job>(name: 'Test3', startedAt: DateTime.now()),
      Execution<Job>(name: 'Test4', startedAt: DateTime.now())
    ];

    for (final execution in executions) {
      stack.push(execution);
    }

    expect(stack.isEmpty, false);
    expect(stack.isNotEmpty, true);

    for (int i = executions.length - 1; i >= 0; i--) {
      expect(stack.pop().name, executions[i].name);
    }

    expect(stack.isEmpty, true);
    expect(stack.isNotEmpty, false);
  });
}
