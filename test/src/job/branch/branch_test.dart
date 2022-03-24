// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:batch/src/job/branch/branch.dart';
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/event/job.dart';

void main() {
  test('Test Branch', () {
    final to = Job(name: 'Job');
    final branch = Branch<Job>(
      on: BranchStatus.completed,
      to: to,
    );

    expect(branch.on, BranchStatus.completed);
    expect(branch.to, to);
  });
}
