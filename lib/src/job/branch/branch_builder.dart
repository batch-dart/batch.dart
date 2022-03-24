// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/job/branch/branch.dart';
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/event/event.dart';

class BranchBuilder<T extends Event<T>> {
  /// The status as a basis for this branching
  BranchStatus? _on;

  /// The next point for this branching
  T? _to;

  /// Sets the branch status.
  BranchBuilder<T> on(final BranchStatus status) {
    _on = status;
    return this;
  }

  /// Sets the next point for this branching.
  BranchBuilder<T> to(final T to) {
    _to = to;
    return this;
  }

  Branch<T> build() {
    if (_on == null) {
      throw ArgumentError('Set the branch status for this branch.');
    }

    if (_to == null) {
      throw ArgumentError('Set the next point for this branch.');
    }

    return Branch<T>(on: _on!, to: _to!);
  }
}
