// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Project imports:
import 'package:batch/batch.dart';

class OutputLogEvent {
  /// Returns the new instance of [OutputLogEvent].
  OutputLogEvent({
    required this.level,
    required this.lines,
  });

  /// The log level
  final LogLevel level;

  /// The lines
  final List<String> lines;
}
