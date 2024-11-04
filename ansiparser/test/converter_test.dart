import 'package:test/test.dart';
import 'package:ansiparser/src/converter.dart';
import 'package:ansiparser/src/structures.dart';

void main() {
  group('Converter Tests', () {
    test('testSgrAttributesToCss', () {
      // Prepare test SGR attributes
      final sgrAttributes = SgrAttributes()
        ..style = {'sgr_1'}
        ..foreground = 'sgr_30'
        ..background = 'sgr_40';

      final cssClass = sgrAttributesToCss(sgrAttributes);

      expect(cssClass, equals('sgr_1 sgr_30 sgr_40'));
    });

    test('testToHtmlValid', () {
      // Prepare test InterConverted object
      final interConverted = InterConverted()
        ..text = ['A', 'B'];

      final sgrAttributes = SgrAttributes()
        ..style = {'sgr_1', 'sgr_2'}
        ..foreground = 'sgr_30'
        ..background = 'sgr_40';

      final sgrAttributes1 = SgrAttributes()
        ..style = {'sgr_1'}
        ..foreground = 'sgr_30'
        ..background = 'sgr_40';

      interConverted.styles = [sgrAttributes, sgrAttributes1];

      final result = toHtml(interConverted);

      expect(result.localName, equals('div'));
      expect(result.querySelectorAll('span').length, equals(2));
      expect(result.querySelectorAll('span')[0].text, equals('A'));
      expect(result.querySelectorAll('span')[0].classes.contains('sgr_30'), isTrue);
    });

    

    test('testToStringValid', () {
      // Prepare test InterConverted object
      final interConverted = InterConverted()
        ..text = ['A', 'B'];

      final sgrAttributes = SgrAttributes()
        ..style = {'sgr_1', 'sgr_2'}
        ..foreground = 'sgr_30'
        ..background = 'sgr_40';

      interConverted.styles = [sgrAttributes, sgrAttributes];

      final result = toString(interConverted);
      expect(result, equals('AB'));
    });

    
  });
}
