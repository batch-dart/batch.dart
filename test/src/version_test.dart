// Copyright (c) 2022, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:batch/src/version.dart';
import 'package:test/test.dart';

void main() {
  final versionRegex = RegExp(
      r"version\:.(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?");

  test('Matches with the current package version in pubspec.yaml', () {
    final path = '${Directory.current.path}/pubspec.yaml';
    String data = File(path).readAsStringSync();
    String? version =
        versionRegex.stringMatch(data)?.replaceFirst('version: ', '');

    expect(version != null, true);
    expect(Version().current, version);
    expect(Version().qualifiedVersion, 'batch.dart (v$version)');
  });
}
