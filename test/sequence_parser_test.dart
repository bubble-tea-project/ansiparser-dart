import 'package:test/test.dart';
import 'package:ansiparser/src/sequence_parser.dart';
import 'package:ansiparser/src/structures.dart';


void main() {
  // Fixtures
  InterConverted createInterConverted() => InterConverted();
  SgrAttributes createSgrAttributes() => SgrAttributes();
  SequenceParser createSequenceParser() => SequenceParser();

  group('_sgrParametersToAttributes Tests', () {
    test('testSgrParametersToAttributesClear', () {
      var sgrAttributes = SgrAttributes()
        ..style = {"bold", "italic"}
        ..foreground = "fg_black"
        ..background = "bg_black";

      var parameters = [0]; // Reset or normal
      var result = sgrParametersToAttributes(parameters, sgrAttributes);
      expect(result.style, isEmpty);
      expect(result.foreground, equals(""));
      expect(result.background, equals(""));
    });

    test('testSgrParametersToAttributes', () {
      var sgrAttributes = SgrAttributes();
      var parameters = [31]; // Set foreground color to sgr_31
      var result = sgrParametersToAttributes(parameters, sgrAttributes);
      expect(result.foreground, equals("fg_red"));
    });
  });

  group('SequenceParser Tests', () {
    final sequenceParser = createSequenceParser();
    final interConverted = createInterConverted();
    final sgrAttributes = createSgrAttributes();

    test('testParseTextAdd', () {
      const text = "Hello";
      var (inter_converted, currentIndex) = sequenceParser.parseText(text, interConverted, sgrAttributes, 0);

      expect(inter_converted.text, equals(text.split("")));
      expect(inter_converted.styles.length, equals(text.length));
      expect(currentIndex, equals(text.length));
    });

    test('testParseTextOverwrite', () {
      var interConverted = InterConverted()
        ..text = "abcde".split("")
        ..styles = List.filled(5, SgrAttributes());

      const text = "XYZ";
      var (inter_converted, currentIndex) = sequenceParser.parseText(text, interConverted, sgrAttributes, 1);
      expect(inter_converted.text, equals("aXYZe".split("")));
      expect(currentIndex, equals(4));
    });

    test('testParseSgr', () {
      const sequence = "\x1b[31m";
      var result = sequenceParser.parseSgr(sequence, sgrAttributes);
      expect(result.foreground, equals("fg_red"));
    });

    test('testParseElClearToEndOfLine', () {
      var interConverted = InterConverted()
        ..text = "Hello World".split("")
        ..styles = List.filled(11, SgrAttributes());

      var result = sequenceParser.parseEl("\x1b[0K", interConverted, 5);
      expect(result.text, equals("Hello".split("")));
    });

    test('testParseElClearToStartOfLine', () {
      var interConverted = InterConverted()
        ..text.addAll("Hello World".split(""))
        ..styles = List.generate(11, (_) => SgrAttributes());

      
      var result = sequenceParser.parseEl("\x1b[1K", interConverted, 5);
      expect(result.text, equals("      World".split("")));
    });

    test('testParseElClearEntireLine', () {
      var interConverted = InterConverted()
        ..text = "Hello World".split("")
        ..styles = List.generate(11, (_) => SgrAttributes());

      var result = sequenceParser.parseEl("\x1b[2K", interConverted, 5);
      expect(result.text, isEmpty);
    });

    test('testParseEdClearToEndOfScreen', () {
      var interConverted = InterConverted()
        ..text = "Hello World".split("")
        ..styles = List.generate(11, (_) => SgrAttributes());
      var parsedScreen = [interConverted];

      var (inter_converted, parsedScreen_) = sequenceParser.parseEd("\x1b[0J", interConverted, 5, parsedScreen, 0);
      expect(inter_converted.text, equals("Hello".split("")));
      expect(parsedScreen_.isEmpty, isTrue);
    });

    test('testParseEdClearEntireScreen', () {
      var interConverted = InterConverted()
        ..text = "Hello World".split("");
      var parsedScreen = [interConverted];

      var (inter_converted, parsedScreen_) = sequenceParser.parseEd("\x1b[2J", interConverted, 5, parsedScreen, 0);
      expect(inter_converted.text, isEmpty);
      expect(parsedScreen_.isEmpty, isTrue);
    });

    test('testParseCup', () {
      var parsedScreen = [interConverted];
      var result = sequenceParser.parseCup("\x1b[10;10H", interConverted, 0, parsedScreen, 0);
      expect(result['currentIndex'], equals(9));
      expect(result['currentLineIndex'], equals(9));
    });

    test('testParseNewline', () {
      var parsedScreen = [interConverted];
      var result = sequenceParser.parseNewline("\r\n", interConverted, 0, parsedScreen, 0);
      expect(result['currentIndex'], equals(0));
      expect(result['currentLineIndex'], equals(1));
    });
  });
}
