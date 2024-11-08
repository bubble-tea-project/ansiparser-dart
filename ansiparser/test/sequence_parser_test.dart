import 'package:test/test.dart';
import 'package:ansiparser/src/sequence_parser.dart';
import 'package:ansiparser/src/structures.dart';

void main() {
  test('test_sgr_parameters_to_attributes_clear', () {
    final sgrAttributes = SgrAttributes()
      ..style = {'bold', 'italic'}
      ..foreground = 'fg_black'
      ..background = 'bg_black';

    final parameters = [0]; // Reset or normal
    final result = sgrParametersToAttributes(parameters, sgrAttributes);

    expect(result.style, isEmpty);
    expect(result.foreground, isEmpty);
    expect(result.background, isEmpty);
  });

  test('test_sgr_parameters_to_attributes', () {
    final sgrAttributes = SgrAttributes();
    final parameters = [31]; // Set foreground color
    final result = sgrParametersToAttributes(parameters, sgrAttributes);

    expect(result.foreground, equals('fg_red'));
  });

  group("Parse...", () {
    late SequenceParser sequenceParser;
    late InterConverted interConverted;
    late SgrAttributes sgrAttributes;

    setUp(() {
      sequenceParser = SequenceParser();
      interConverted = InterConverted();
      sgrAttributes = SgrAttributes();
    });

    group('ParseText', () {
      test('test_add', () {
        final text = 'Hello';
        int currentIndex;
        (interConverted, currentIndex) =
            sequenceParser.parseText(text, interConverted, sgrAttributes, 0);

        expect(interConverted.text, equals(text.split('')));
        expect(interConverted.styles.length, equals(text.length));
        expect(currentIndex, equals(text.length));
      });

      test('test_overwrite', () {
        interConverted.text.addAll(['a', 'b', 'c', 'd', 'e']);
        interConverted.styles = List.generate(5, (_) => SgrAttributes());

        final text = 'XYZ';
        int currentIndex;
        (interConverted, currentIndex) =
            sequenceParser.parseText(text, interConverted, SgrAttributes(), 1);

        expect(interConverted.text, equals(['a', 'X', 'Y', 'Z', 'e']));
        expect(currentIndex, equals(4)); // index at 'e'
      });
    });

    test('test_parse_sgr', () {
      final sequence = '\x1b[31m'; // Foreground color, red
      final result = sequenceParser.parseSgr(sequence, sgrAttributes);

      expect(result.foreground, equals('fg_red'));
    });

    group('ParseEl', () {
      test('test_to_end_of_line', () {
        interConverted.text.addAll('Hello World'.split(''));
        interConverted.styles =
            List.generate(interConverted.text.length, (_) => SgrAttributes());

        final result = sequenceParser.parseEl('\x1b[0K', interConverted, 5);

        expect(result.text, equals('Hello'.split('')));
      });

      test('test_to_start_of_line', () {
        interConverted.text.addAll('Hello World'.split(''));
        interConverted.styles =
            List.generate(interConverted.text.length, (_) => SgrAttributes());

        final result = sequenceParser.parseEl('\x1b[1K', interConverted, 5);

        expect(result.text, equals('      World'.split('')));
      });

      test('test_entire_line', () {
        interConverted.text.addAll('Hello World'.split(''));
        interConverted.styles =
            List.generate(interConverted.text.length, (_) => SgrAttributes());

        final result = sequenceParser.parseEl('\x1b[2K', interConverted, 5);

        expect(result.text, isEmpty);
      });
    });

    group('ParseEd', () {
      late List<InterConverted> parsedScreen;

      setUp(() {
        //
        parsedScreen = () {
          interConverted.text.addAll('Hello World'.split(''));
          interConverted.styles =
              List.generate(interConverted.text.length, (_) => SgrAttributes());

          return [interConverted.copy(), interConverted.copy()];
        }();
      });

      test('test_to_end_of_screen', () {
        interConverted = parsedScreen[0];

        (interConverted, parsedScreen) = sequenceParser.parseEd(
            '\x1b[0J', interConverted, 5, parsedScreen, 0);

        expect(interConverted.text, equals('Hello'.split('')));
        expect(parsedScreen.length, equals(1));
      });

      test('test_to_start_of_screen', () {
        interConverted = parsedScreen[1];

        (interConverted, parsedScreen) = sequenceParser.parseEd(
            '\x1b[1J', interConverted, 5, parsedScreen, 1);

        expect(interConverted.text, equals('      World'.split('')));
        expect(parsedScreen.length, equals(2));
      });

      test('test_entire_screen', () {
        interConverted = parsedScreen[0];

        (interConverted, parsedScreen) = sequenceParser.parseEd(
            '\x1b[2J', interConverted, 5, parsedScreen, 0);

        expect(interConverted.text, isEmpty);
        expect(parsedScreen, isEmpty);
      });
    });

    test('test_parse_cup', () {
      final parsedScreen = [interConverted];

      final result = sequenceParser.parseCup(
          '\x1b[10;10H', interConverted, 0, parsedScreen, 0);

      expect(result['currentIndex'], equals(9));
      expect(result['currentLineIndex'], equals(9));
    });

    test('test_parse_newline', () {
      final parsedScreen = [interConverted];

      final result = sequenceParser.parseNewline(
          '\r\n', interConverted, 0, parsedScreen, 0);

      expect(result['currentIndex'], equals(0));
      expect(result['currentLineIndex'], equals(1));
    });
  });
}
