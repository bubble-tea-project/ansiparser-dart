import 'package:test/test.dart';
import 'package:ansiparser/src/structures.dart';

void main() {
  group('WCharPH', () {
    test('test_wcharph_init', () {
      final wcharph = WCharPH();
      expect(wcharph, isA<WCharPH>());
    });
  });

  group('SgrAttributes', () {
    test('test_init', () {
      final sgrAttr = SgrAttributes();

      expect(sgrAttr.style, equals(<String>{}));
      expect(sgrAttr.background, equals(''));
      expect(sgrAttr.foreground, equals(''));
    });

    test('test_equality', () {
      final sgr1 = SgrAttributes();
      final sgr2 = SgrAttributes();
      expect(sgr1, equals(sgr2));

      sgr1.style.add('bold');
      expect(sgr1, isNot(equals(sgr2)));
    });

    test('test_clear', () {
      final sgr = SgrAttributes();
      sgr.style.add('bold');
      sgr.background = 'fg_blue';
      sgr.foreground = 'bg_white';
      sgr.clear();

      expect(sgr.style, equals(<String>{}));
      expect(sgr.background, equals(''));
      expect(sgr.foreground, equals(''));
    });

    test('test_empty', () {
      final sgr = SgrAttributes();
      expect(sgr.empty(), isTrue);

      sgr.style.add('bold');
      expect(sgr.empty(), isFalse);
    });
  });

  group('InterConverted', () {
    test('test_init', () {
      final interConverted = InterConverted();
      expect(interConverted.text, equals([]));
      expect(interConverted.styles, equals([]));
    });

    test('test_interconverted_clear', () {
      final interConverted = InterConverted();
      interConverted.text.add('t');
      interConverted.styles.add(SgrAttributes());
      interConverted.clear();

      expect(interConverted.text, equals([]));
      expect(interConverted.styles, equals([]));
    });

    test('test_empty', () {
      final interConverted = InterConverted();
      expect(interConverted.empty(), isTrue);

      interConverted.text.add('t');
      interConverted.styles.add(SgrAttributes());
      expect(interConverted.empty(), isFalse);
    });

    test('test_interconverted_validate', () {
      final interConverted = InterConverted();
      interConverted.text = ['t'];
      interConverted.styles = [SgrAttributes()];
      expect(interConverted.validate(), isTrue);

      interConverted.text.add('e');
      expect(interConverted.validate(), isFalse);
    });
  });
}
