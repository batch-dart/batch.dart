// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:batch/src/banner/default_banner.dart';

void main() {
  test('Test DefaultBanner', () {
    expect(DefaultBanner().build(), _builtBanner);
  });
}

/// The built banner
const _builtBanner = '''
╔═════════════════════════════════════════════════════════════════════════╗
║                                                                         ║
║  ╭━━╮╱╱╱╭╮╱╱╱╭╮╱╱╱╱╭╮╱╱╱╱╭╮                                             ║
║  ┃╭╮┃╱╱╭╯╰╮╱╱┃┃╱╱╱╱┃┃╱╱╱╭╯╰╮                                            ║
║  ┃╰╯╰┳━┻╮╭╋━━┫╰━╮╭━╯┣━━┳┻╮╭╯                                            ║
║  ┃╭━╮┃╭╮┃┃┃╭━┫╭╮┃┃╭╮┃╭╮┃╭┫┃                                             ║
║  ┃╰━╯┃╭╮┃╰┫╰━┫┃┃┣┫╰╯┃╭╮┃┃┃╰╮                                            ║
║  ╰━━━┻╯╰┻━┻━━┻╯╰┻┻━━┻╯╰┻╯╰━╯                                            ║
║  ╱╱╭╮╱╱╭╮╱╱╭━━━╮╱╱╭╮╱╱╱╱╱╱╭╮╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮     ║
║  ╱╱┃┃╱╱┃┃╱╱┃╭━╮┃╱╱┃┃╱╱╱╱╱╱┃┃╱╱┃┃╱╱╱╱╱╱╱╱┃╭━━╯╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱┃┃     ║
║  ╱╱┃┣━━┫╰━╮┃╰━━┳━━┫╰━┳━━┳━╯┣╮╭┫┃╭┳━╮╭━━╮┃╰━━┳━┳━━┳╮╭┳━━┳╮╭╮╭┳━━┳━┫┃╭╮   ║
║  ╭╮┃┃╭╮┃╭╮┃╰━━╮┃╭━┫╭╮┃┃━┫╭╮┃┃┃┃┃┣┫╭╮┫╭╮┃┃╭━━┫╭┫╭╮┃╰╯┃┃━┫╰╯╰╯┃╭╮┃╭┫╰╯╯   ║
║  ┃╰╯┃╰╯┃╰╯┃┃╰━╯┃╰━┫┃┃┃┃━┫╰╯┃╰╯┃╰┫┃┃┃┃╰╯┃┃┃╱╱┃┃┃╭╮┃┃┃┃┃━╋╮╭╮╭┫╰╯┃┃┃╭╮╮   ║
║  ╰━━┻━━┻━━╯╰━━━┻━━┻╯╰┻━━┻━━┻━━┻━┻┻╯╰┻━╮┃╰╯╱╱╰╯╰╯╰┻┻┻┻━━╯╰╯╰╯╰━━┻╯╰╯╰╯   ║
║  ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭━╯┃                                ║
║  ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯                                ║
║                                                                         ║
╠═════════════════════════════════════════════════════════════════════════╣
║  Version  : 1.2.0                                                       ║
║  License  : BSD 3-Clause                                                ║
║  Author   : Kato Shinya (https://github.com/myConsciousness)            ║
╚═════════════════════════════════════════════════════════════════════════╝
''';
