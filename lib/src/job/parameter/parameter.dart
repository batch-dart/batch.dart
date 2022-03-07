// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Parameter {
  /// Returns the new instance of [Parameter].
  Parameter({
    required this.key,
    required this.value,
  });

  /// The key
  final String key;

  /// The value
  final dynamic value;

  @override
  String toString() => '$key=$value';
}