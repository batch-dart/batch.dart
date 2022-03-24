// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart imports:
import 'dart:async';

// Project imports:
import 'package:batch/src/job/branch/branch.dart';
import 'package:batch/src/job/branch/branch_builder.dart';
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/config/retry_configuration.dart';
import 'package:batch/src/job/config/skip_configuration.dart';
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/policy/retry_policy.dart';
import 'package:batch/src/job/policy/skip_policy.dart';

/// This is an abstract class that represents an event in Job execution.
abstract class Event<T extends Event<T>> {
  /// Returns the new instance of [Event].
  Event({
    required this.name,
    this.precondition,
    this.onStarted,
    this.onSucceeded,
    this.onError,
    this.onCompleted,
    SkipConfiguration? skipConfig,
    RetryConfiguration? retryConfig,
  })  : skipPolicy =
            skipConfig != null ? SkipPolicy(skipConfig: skipConfig) : null,
        retryPolicy =
            retryConfig != null ? RetryPolicy(retryConfig: retryConfig) : null;

  /// The name
  final String name;

  /// The precondition
  final FutureOr<bool> Function()? precondition;

  /// The callback when this process is started
  final Function(ExecutionContext context)? onStarted;

  /// The callback when this process is succeeded
  final Function(ExecutionContext context)? onSucceeded;

  /// The callback when this process is stopped due to exception
  final Function(
    ExecutionContext context,
    dynamic error,
    StackTrace stackTrace,
  )? onError;

  /// The callback when this process is completed (regardless of success and failure)
  final Function(ExecutionContext context)? onCompleted;

  /// The skip policy
  final SkipPolicy? skipPolicy;

  /// The retry policy
  final RetryPolicy? retryPolicy;

  /// The branches
  final List<Branch<T>> branches = [];

  /// Returns true if this event can launch, otherwise false.
  Future<bool> shouldLaunch() async => await precondition?.call() ?? true;

  /// Add a branch in case the parent process is succeeded.
  void branchOnSucceeded({required T to}) =>
      _addNewBranch(on: BranchStatus.succeeded, to: to);

  /// Adds a branch in case the parent process is failed.
  void branchOnFailed({required T to}) =>
      _addNewBranch(on: BranchStatus.failed, to: to);

  /// Adds a branch in case the parent process is completed regardless success
  /// and failure of the process.
  void branchOnCompleted({required T to}) =>
      _addNewBranch(on: BranchStatus.completed, to: to);

  /// Returns true if this event has branch, otherwise false.
  bool get hasBranch => branches.isNotEmpty;

  /// Returns true if this event has skip policy, otherwise false.
  bool get hasSkipPolicy => skipPolicy != null;

  /// Returns true if this event has retry policy, otherwise false.
  bool get hasRetryPolicy => retryPolicy != null;

  /// Adds new [Branch] based on [on] and [to].
  void _addNewBranch({required BranchStatus on, required T to}) =>
      branches.add(BranchBuilder<T>().on(on).to(to).build());
}
