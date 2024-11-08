import 'package:test/test.dart';
import 'package:ansiparser/src/screen_parser.dart';

void main() {
  test('test_apply_backspace', () {
    final result = applyBackspace('hel\x08lo');
    expect(result, equals('helo'));
  });

  test('test_split_by_ansi', () {
    final result = splitByAnsi('hello\x1B[31mworld\x1B[0m');
    expect(result, equals(['hello', '\x1B[31m', 'world', '\x1B[0m']));
  });

  group('ScreenParser', () {
    late ScreenParser screenParser;

    setUp(() {
      screenParser = ScreenParser();
    });

    test('test_put', () {
      screenParser.put('Hello');

      expect(screenParser.buffer()!.length, equals(1));
      expect(screenParser.buffer()!.first, equals(['Hello']));

      screenParser.put('\x1B[2J');
      expect(screenParser.buffer()!.length, equals(2));
      expect(screenParser.buffer()!.last, equals(['\x1B[2J']));
      expect(screenParser.lastScreenFinish, isTrue);
    });

    test('test_parse', () {
      screenParser.put('Hello\nWorld');
      screenParser.parse();

      final parsedScreen = screenParser.getParsedScreen();
      expect(parsedScreen.length, equals(2));
    });

    test('test_clear', () {
      screenParser.put('Hello\nWorld');
      screenParser.parse();

      screenParser.clear();
      expect(screenParser.getParsedScreen(), isEmpty);
      expect(screenParser.currentLineIndex, equals(0));
      expect(screenParser.currentIndex, equals(0));
    });

    test('test_to_formatted_string', () {
      screenParser.put('Hello\nWorld');
      screenParser.parse();

      final formattedString = screenParser.toFormattedString();
      expect(formattedString, equals(['Hello', '     World']));
    });

    test('test_to_html', () {
      screenParser.put('Hello\nWorld');
      screenParser.parse();

      final htmlOutput = screenParser.toHtml();
      expect(
          htmlOutput,
          equals([
            '<div class="line"><span class="">Hello</span></div>',
            '<div class="line"><span class="">     World</span></div>'
          ]));
    });
  });
}
