// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/banner/banner_printer.dart';
import 'package:batch/src/banner/default_banner.dart';
import 'package:batch/src/diagnostics/boot_diagnostics.dart';
import 'package:batch/src/job/event/job.dart';
import 'package:batch/src/job/parameter/shared_parameters.dart';
import 'package:batch/src/job/schedule/job_scheduler.dart';
import 'package:batch/src/log/log_configuration.dart';
import 'package:batch/src/log/logger.dart';
import 'package:batch/src/log/logger_provider.dart';
import 'package:batch/src/runner.dart';
import 'package:batch/src/version/update_notification.dart';
import 'package:batch/src/version/version.dart';

/// This is a batch application that manages the execution of arbitrarily defined jobs
/// with own lifecycle.
///
/// In order to run this batch application, you first need to create at least
/// one [Job] object. After creating the Job object, use the [addJob] method to register
/// the Job to the batch application.
///
/// [Job] represents the maximum unit of a certain processing system
/// that consists of multiple steps. In addition, a Step consists of multiple Tasks. Step
/// is an intermediate concept between Job and Task, and Task is the specific
/// minimum unit of processing in a particular processing system.
///
/// You can use [addSharedParameter] to add a value that will be shared by the
/// entire this batch application. This value can be added by tying it to string key and
/// can be used in the Task class throughout the execution context.
///
/// Also you can get more information about implementation on
/// [example page](https://github.com/batch-dart/batch.dart/blob/main/example/example.dart).
///
/// These job configuration can be assembled in any way you like. For example,
/// you can configure it as follows.
///
/// ```
/// BatchApplication
/// │
/// │              ┌ Task1
/// │      ┌ Step1 ├ Task2
/// │      │       └ Task3
/// │      │
/// │      │       ┌ Task1
/// ├ Job1 ├ Step2 ├ Task2
/// │      │       └ Task3
/// │      │
/// │      │       ┌ Task1
/// │      └ Step3 ├ Task2
/// │              └ Task3
/// │
/// │              ┌ Task1
/// │      ┌ Step1 ├ Task2
/// │      │       └ ┄
/// │      │
/// │      │       ┌ Task1
/// └ Job2 ├ Step2 ├ ┄
///        │       └ ┄
///        │
///        │
///        └ ┄
/// ```
abstract class BatchApplication implements Runner {
  /// Returns the new instance of [BatchApplication].
  factory BatchApplication({LogConfiguration? logConfig}) =>
      _BatchApplication(logConfig: logConfig);

  /// Adds [Job].
  void addJob(final Job job);

  /// Adds parameter as global scope.
  void addSharedParameter({
    required String key,
    required dynamic value,
  });
}

class _BatchApplication implements BatchApplication {
  /// Returns the new instance of [_BatchApplication].
  _BatchApplication({LogConfiguration? logConfig}) : _logConfig = logConfig;

  /// The configuration for logging
  final LogConfiguration? _logConfig;

  /// The jobs
  final _jobs = <Job>[];

  @override
  void addJob(final Job job) => _jobs.add(job);

  @override
  void addSharedParameter({
    required String key,
    required dynamic value,
  }) =>
      SharedParameters.instance[key] = value;

  @override
  void run() async {
    try {
      //! The logging functionality provided by the batch library
      //! will be available when this loading process is complete.
      Logger.loadFrom(config: _logConfig ?? LogConfiguration());

      await BannerPrinter(banner: DefaultBanner()).execute();
      await UpdateNotification().printIfNecessary(await Version().status);

      info('🚀🚀🚀🚀🚀🚀🚀 The batch process has started! 🚀🚀🚀🚀🚀🚀🚀');
      info('Logger instance has completed loading');

      BootDiagnostics(jobs: _jobs).run();
      JobScheduler(jobs: _jobs).run();
    } catch (e) {
      Logger.instance.dispose();
      throw Exception(e);
    }
  }
}
