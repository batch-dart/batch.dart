// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/event/task.dart';

/// This is a convenience class that only notifies about application shutdown.
class ShutdownTask extends Task<ShutdownTask> {
  @override
  void execute(ExecutionContext context) => super.shutdown();
}
