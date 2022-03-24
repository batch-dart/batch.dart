// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/job/event/job.dart';
import 'package:batch/src/job/event/step.dart';
import 'package:batch/src/job/event/task.dart';
import 'package:batch/src/job/execution.dart';
import 'package:batch/src/job/parameter/parameters.dart';
import 'package:batch/src/job/parameter/shared_parameters.dart';

/// This class represents a context for managing metadata that is accumulated
/// as a batch application is executed.
class ExecutionContext {
  /// The current job execution
  Execution<Job>? jobExecution;

  /// The current step execution
  Execution<Step>? stepExecution;

  /// The current task execution
  Execution<Task>? taskExecution;

  /// The shared parameters
  final Parameters sharedParameters = SharedParameters.instance;

  /// The job parameters
  final Parameters jobParameters = Parameters();

  /// The step parameters
  final Parameters stepParameters = Parameters();
}
