import 'package:test/test.dart';

import 'package:ansiparser/src/api.dart';
import 'package:ansiparser/src/screen_parser.dart';
import 'package:ansiparser/src/structures.dart';

void main() {
  group('TestNewScreen', () {
    test('test_default', () {
      final ansipScreen = newScreen();

      expect(ansipScreen, isA<ScreenParser>());
      expect(ansipScreen.screenHeight, equals(24));
      expect(ansipScreen.screenWidth, equals(80));
    });

    test('test_custom', () {
      final ansipScreen = newScreen(height: 30, width: 100);

      expect(ansipScreen, isA<ScreenParser>());
      expect(ansipScreen.screenHeight, equals(30));
      expect(ansipScreen.screenWidth, equals(100));
    });
  });

  group('TestfromScreen', () {
    test('test_normal', () {
      final normalParsedScreen = <InterConverted>[];

      for (var i = 0; i < 2; i++) {
        final interConverted = InterConverted();
        interConverted.text = ['t', 'e', 's', 't'];
        interConverted.styles = List.generate(4, (_) => SgrAttributes());

        normalParsedScreen.add(interConverted);
      }

      final ansipScreen = fromScreen(normalParsedScreen);
      expect(ansipScreen, isA<ScreenParser>());
    });

    test('test_invalid', () {
      final invalidParsedScreen = null;
      expect(() => fromScreen(invalidParsedScreen), throwsA(isA<TypeError>()));
    });
  });
}
