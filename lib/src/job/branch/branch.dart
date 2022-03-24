// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/event/event.dart';

class Branch<T extends Event<T>> {
  /// Returns the new instance of [Branch].
  Branch({
    required this.on,
    required this.to,
  });

  /// The status as a basis for this branching
  final BranchStatus on;

  /// The next point for this branching
  final T to;
}
