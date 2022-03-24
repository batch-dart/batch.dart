// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/event/event.dart';
import 'package:batch/src/job/process_status.dart';

class Execution<T extends Event<T>> {
  /// Returns the new instance of [Execution].
  Execution({
    required this.name,
    ProcessStatus status = ProcessStatus.running,
    required this.startedAt,
    DateTime? updatedAt,
    this.finishedAt,
  })  : assert(name.isNotEmpty),
        _status = status,
        _updatedAt = updatedAt;

  /// The name
  final String name;

  /// The process status
  final ProcessStatus _status;

  /// The branch status
  BranchStatus _branchStatus = BranchStatus.completed;

  /// The started date time
  final DateTime startedAt;

  /// The updated date time
  DateTime? _updatedAt;

  /// The finished date time
  DateTime? finishedAt;

  /// Returns the branch status.
  BranchStatus get branchStatus => _branchStatus;

  /// Returns the updated date time.
  DateTime? get updatedAt => _updatedAt;

  /// Updates branch status to succeeded.
  void branchToSucceeded() => _updateBranchStatus(BranchStatus.succeeded);

  /// Updates branch status to failed.
  void branchToFailed() => _updateBranchStatus(BranchStatus.failed);

  /// Updates branch status to completed.
  void branchToCompleted() => _updateBranchStatus(BranchStatus.completed);

  /// Returns true if this execution is running, otherwise false.
  bool get isRunning => _status == ProcessStatus.running;

  /// Returns true if this execution is skipped, otherwise false.
  bool get isSkipped => _status == ProcessStatus.skipped;

  /// Returns true if this execution is completed, otherwise false.
  bool get isCompleted => _status == ProcessStatus.completed;

  void _updateBranchStatus(final BranchStatus status) {
    _branchStatus = status;
    _updatedAt = DateTime.now();
  }
}
