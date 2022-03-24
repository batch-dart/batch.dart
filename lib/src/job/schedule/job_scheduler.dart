// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:clock/clock.dart';

// Project imports:
import 'package:batch/src/batch_instance.dart';
import 'package:batch/src/batch_status.dart';
import 'package:batch/src/job/event/job.dart';
import 'package:batch/src/job/launcher/job_launcher.dart';
import 'package:batch/src/job/schedule/model/schedule.dart';
import 'package:batch/src/job/schedule/scheduled_task.dart';
import 'package:batch/src/log/logger.dart';
import 'package:batch/src/log/logger_provider.dart';
import 'package:batch/src/runner.dart';

class JobScheduler implements Runner {
  /// Returns the new instance of [JobScheduler].
  JobScheduler({required List<Job> jobs}) : _jobs = jobs;

  /// The jobs
  final List<Job> _jobs;

  /// The schedules
  final List<ScheduledTask> _scheduledTasks = [];

  /// The timer
  Timer? _timer;

  @override
  void run() {
    info('Started Job scheduling on startup');
    info('Detected ${_jobs.length} Jobs on the root');

    for (final job in _jobs) {
      info('Scheduling Job [name=${job.name}]');

      _schedule(job.schedule!.parse(), () async {
        try {
          await JobLauncher(job: job).run();
        } catch (error, stackTrace) {
          BatchInstance.instance.updateStatus(BatchStatus.shuttingDown);
          fatal('Shut down the application due to a fatal exception', error,
              stackTrace);
        }
      });
    }

    BatchInstance.instance.updateStatus(BatchStatus.running);

    info(
      'Job scheduling has been completed and the batch application is now running',
    );
  }

  void _schedule(Schedule schedule, Task task) {
    _scheduledTasks.add(ScheduledTask(schedule: schedule, task: task));
    _scheduleNext();
  }

  void _scheduleNext() {
    if (_timer != null) {
      return;
    }

    final now = clock.now();
    final isTickSeconds =
        _scheduledTasks.any((task) => task.schedule.hasSeconds);
    final ms = (isTickSeconds ? 1 : 60) * Duration.millisecondsPerSecond -
        (now.millisecondsSinceEpoch %
            ((isTickSeconds ? 1 : 60) * Duration.millisecondsPerSecond));

    _timer = Timer(Duration(milliseconds: ms), _tick);
  }

  void _tick() {
    if (BatchInstance.instance.isShuttingDown) {
      _dispose();
      return;
    }

    _timer = null;

    final now = clock.now();
    for (final scheduledTask in _scheduledTasks) {
      scheduledTask.tick(now);
    }

    _scheduleNext();
  }

  void _dispose() {
    warn('Preparing for shutdown the batch application safely');

    for (final scheduledTask in _scheduledTasks) {
      scheduledTask.dispose();
    }

    warn('Allocation memory is releasing');
    warn('Shutdown the batch application');
    Logger.instance.dispose();
    BatchInstance.instance.updateStatus(BatchStatus.shutdown);
  }
}
