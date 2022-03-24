# 1. Style Guide

<!-- TOC -->

- [1. Style Guide](#1-style-guide)
  - [1.1. Code Formatting](#11-code-formatting)
    - [1.1.1. Max line length](#111-max-line-length)
    - [1.1.2. Trailing Commas and Wrapping](#112-trailing-commas-and-wrapping)
    - [1.1.3. Imports](#113-imports)
  - [1.2. Code Structure](#12-code-structure)
    - [1.2.1. Global Variables](#121-global-variables)
    - [1.2.2. Asserts](#122-asserts)
  - [1.3. Comments](#13-comments)
    - [1.3.1. TODO](#131-todo)
    - [1.3.2. Dartdocs](#132-dartdocs)
      - [1.3.2.1. Consider adding examples](#1321-consider-adding-examples)
      - [1.3.2.2. Avoid useless code documentation](#1322-avoid-useless-code-documentation)
      - [1.3.2.3. Consider adding linkage between docs](#1323-consider-adding-linkage-between-docs)

<!-- /TOC -->

This is a general style guide that shall govern batch.dart repository. The aim is to keep
all code bases clean and pristine. This includes high level guidance to help with simple decisions
in the day-to-day development life.

This extends rules on the official [Flutter Style
Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) and [Effective Dart
Patterns](https://dart.dev/guides/language/effective-dart). Those rules apply unless otherwise
specified in this document.

Note that this is not yet an exhaustive guide, and consider it a work in progress. PRs are welcome!

## 1.1. Code Formatting

### 1.1.1. Max line length

For all files, including markdown, keep each line within a hundred or less characters.

### 1.1.2. Trailing Commas and Wrapping

List of elements must always be all in one line or one element per line. This includes parameters,
arguments, collection literals, etc. Furthermore, if multiline, the last element must have a
trailing comma.

For the sake of example, let's use a function invocation (the same apply for all cases):

```dart
// good
foo(p1, p2, p3)

// good
foo(
    p1,
    p2,
    p3,
)

// bad: missing trailing comma
foo(
    p1,
    p2,
    p3
)

// bad: mixed argument lines
foo(
    p1, p2,
    p3,
)

// bad: mixed argument lines
foo(f1,
    f2)
```

### 1.1.3. Imports

- Never include unused or duplicated imports.
- You must always use relative imports for imports within the batch.dart library (internal imports must
  be relative).
- Omit `./` for relative imports from the same directory.
- Avoid importing groups of APIs internally.
- Order your imports by `import_sorter`.

For example:

```dart
// Project imports:
import 'package:batch/src/batch_instance.dart';
import 'package:batch/src/job/branch/branch_status.dart';
import 'package:batch/src/job/context/context_support.dart';
import 'package:batch/src/job/context/execution_context.dart';
import 'package:batch/src/job/event/event.dart';
import 'package:batch/src/job/process_status.dart';
import 'package:batch/src/log/logger_provider.dart';
import 'package:batch/src/runner.dart';
```

## 1.2. Code Structure

### 1.2.1. Global Variables

Do not use public global variables or constants; namespace everything inside appropriate scopes.

### 1.2.2. Asserts

Use asserts to detect contract violation.

Example:

```dart
void something(int smaller, int bigger) {
  assert(small < bigger, 'smaller is not smaller than bigger');
  // ...
}
```

## 1.3. Comments

- For any `//` comments, always add a space after the second slash and before the next character.
- Use `//` (or block comments) for comments about the code; use `///` for dartdocs about APIs.

### 1.3.1. TODO

TODO comments should follow this template: `// TODO(username): Comment`

I.e., double slash, one space, `TODO` in caps followed by your name in parenthesis, colon, one space
and the comment, capitalized as a sentence. No need to include a period if it's a single sentence.

```dart
// bad: missing identifier, mixed-case "TODO" and lowercase comment

// Todo: this thing should be that thing
final thisThing = 13;

// good:

// TODO(batch-dart): This thing should be that thing
const thisThing = 13;
```

### 1.3.2. Dartdocs

#### 1.3.2.1. Consider adding examples

Some elements may benefit from a simple usage example.

#### 1.3.2.2. Avoid useless code documentation

Avoid documentation that just repeats the obvious. For example, `void doStuff()` be documented as
"Method that does stuff".

#### 1.3.2.3. Consider adding linkage between docs

You should use `[]` (brackets) to link dartdoc elements that can be referenced on the same file.
Also, consider adding a "See also" section to element documentation.
