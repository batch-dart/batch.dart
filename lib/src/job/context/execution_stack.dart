// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Project imports:
import 'package:batch/src/job/execution.dart';

/// The class represents stack structure of [Execution].
abstract class ExecutionStack {
  /// Returns the new instance of [ExecutionStack].
  factory ExecutionStack() => _ExecutionStack();

  /// Adds [execution].
  void push(final Execution execution);

  /// Returns the [Execution] object from the back.
  Execution pop();

  /// Returns true if this stack is empty, otherwise false.
  bool get isEmpty;

  /// Returns true if this stack is not empty, otherwise false.
  bool get isNotEmpty;
}

/// The implementation class of [ExecutionStack].
class _ExecutionStack implements ExecutionStack {
  /// The values
  final _values = <Execution>[];

  @override
  void push(Execution execution) => _values.add(execution);

  @override
  Execution pop() {
    assert(_values.isNotEmpty);
    return _values.removeLast();
  }

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;
}
