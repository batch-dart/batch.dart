// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:batch/src/job/parameter/shared_parameters.dart';

void main() {
  test('Test SharedParameters', () {
    expect(SharedParameters.instance, SharedParameters.instance);
  });
}
