import 'package:test/test.dart';
import 'package:ansiparser/src/converter.dart';
import 'package:ansiparser/src/structures.dart';

void main() {
  test('test_sgr_attributes_to_css', () {
    final sgrAttributes = SgrAttributes()
      ..style = {'bold'}
      ..foreground = 'fg_blue'
      ..background = 'bg_white';

    expect(sgrAttributesToCss(sgrAttributes), equals('bold fg_blue bg_white'));
  });

  group("to...", () {
    late InterConverted validInterConverted;
    late InterConverted invalidInterConverted;

    InterConverted createValidInterConverted() {
      final interConverted = InterConverted();
      interConverted.text = ['R', ' ', 'G'];

      final attributeRed = SgrAttributes()..background = 'fg_red';
      final attributeGreen = SgrAttributes()..foreground = 'fg_green';

      interConverted.styles = [attributeRed, attributeRed, attributeGreen];
      return interConverted;
    }

    InterConverted createInvalidInterConverted() {
      final interConverted = InterConverted();
      interConverted.text = ['R', ' ', 'G'];

      final sgrAttributes = SgrAttributes();
      interConverted.styles = [sgrAttributes];
      return interConverted;
    }

    setUp(() {
      validInterConverted = createValidInterConverted();
      invalidInterConverted = createInvalidInterConverted();
    });

    test('test_to_html_valid', () {
      final result = toHtml(validInterConverted).outerHtml;
      final expected =
          '<div class="line"><span class="fg_red">R </span><span class="fg_green">G</span></div>';

      expect(result, equals(expected));
    });

    test('test_to_html_invalid', () {
      expect(
          () => toHtml(invalidInterConverted), throwsA(isA<ArgumentError>()));
    });

    test('test_to_string_valid', () {
      final result = toString(validInterConverted);

      expect(result, equals('R G'));
    });

    test('test_to_string_invalid', () {
      expect(
          () => toString(invalidInterConverted), throwsA(isA<ArgumentError>()));
    });
  });
}
