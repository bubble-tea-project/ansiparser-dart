<h1 align="center">AnsiParser-dart</h1>

<div align="center">

The [AnsiParser](https://github.com/bubble-tea-project/ansiparser) library implemented in Dart.


[![Pub Version](https://img.shields.io/pub/v/ansiparser)](https://pub.dev/packages/ansiparser)
[![GitHub License](https://img.shields.io/github/license/bubble-tea-project/ansiparser-dart)](https://github.com/bubble-tea-project/ansiparser-dart/blob/main/LICENSE)

</div>

## 📖 Description
Parse ANSI escape sequences into screen outputs. This library implements a parser that processes escape sequences like a terminal, allowing you to convert them into formatted text or HTML.


## 📦 Installation
AnsiParser is available on [Pub](https://pub.dev/packages/ansiparser):
```bash
pub add ansiparser
```


## 🎨 Usage
```dart
import 'package:ansiparser/ansiparser.dart' as ansiparser;

void main() {
  final ansipScreen = ansiparser.newScreen();
  ansipScreen.put('\x1b[1;6H-World!\x1b[1;1HHello');

  ansipScreen.parse();
  final converted = ansipScreen.toFormattedString();

  print(converted); // ['Hello-World!']
}

```


## 🔗 Links
- [AnsiParser Python Version](https://github.com/bubble-tea-project/ansiparser)
- [AnsiParser Documentation (Python)](https://bubble-tea-project.github.io/ansiparser/)


## 📜 License
[![GitHub License](https://img.shields.io/github/license/bubble-tea-project/ansiparser-dart)](https://github.com/bubble-tea-project/ansiparser-dart/blob/main/LICENSE)





