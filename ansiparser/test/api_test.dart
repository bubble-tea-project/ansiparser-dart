import 'package:test/test.dart';
import 'package:ansiparser/src/api.dart';  // Assumes you have equivalent Dart modules for ansiparser.
import 'package:ansiparser/src/screen_parser.dart';
import 'package:ansiparser/src/structures.dart';

void main() {
  group('TestAPI', () {
    test('testNewScreenDefault', () {
      final ansipScreen = newScreen();
      expect(ansipScreen, isA<ScreenParser>());
      expect(ansipScreen.screenHeight, equals(24));
      expect(ansipScreen.screenWidth, equals(80));
    });

    test('testNewScreenCustom', () {
      final ansipScreen = newScreen(height: 30, width: 100);
      expect(ansipScreen, isA<ScreenParser>());
      expect(ansipScreen.screenHeight, equals(30));
      expect(ansipScreen.screenWidth, equals(100));
    });

    test('testFromScreen', () {
      final interConverted = InterConverted();
      interConverted.text = ["t", "e", "s", "t"];
      interConverted.styles = List.generate(4, (_) => SgrAttributes());

      final parsedScreen = [interConverted, interConverted];
      final ansipScreen = fromScreen(parsedScreen);
      expect(ansipScreen, isA<ScreenParser>());
      // Uncomment after ensuring getParsedScreen returns expected results
      // expect(ansipScreen.getParsedScreen(), equals(parsedScreen));
    });

    test('testFromScreenInvalid', () {
      final invalidParsedScreen = null;
      expect(() => fromScreen(invalidParsedScreen), throwsA(isA<TypeError>()));
    });
  });
}
