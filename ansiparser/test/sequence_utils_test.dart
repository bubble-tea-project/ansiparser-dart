import 'package:test/test.dart';
import 'package:ansiparser/src/sequence_utils.dart';

void main() {
  group('TestCSIChecker', () {
    late CSIChecker csiChecker;

    setUp(() {
      csiChecker = CSIChecker();
    });

    test('test_is_csi', () {
      expect(csiChecker.isCsi("\x1b[1;6H-World!\x1b[1;1HHello"), isTrue);
      expect(csiChecker.isCsi("Not a CSI sequence"), isFalse);
    });

    test('test_is_sgr_sequence', () {
      expect(csiChecker.isSgrSequence("\x1b[1;37m推"), isTrue);
      expect(csiChecker.isSgrSequence("\x1b[1;6H-World"), isFalse);
    });

    test('test_is_ed_sequence', () {
      expect(csiChecker.isEdSequence("\x1B[1J"), isTrue);
      expect(csiChecker.isEdSequence("\x1B[2K"), isFalse);
    });

    test('test_is_el_sequence', () {
      expect(csiChecker.isElSequence("\x1B[2K"), isTrue);
      expect(csiChecker.isElSequence("\x1B[1J"), isFalse);
    });

    test('test_is_cup_sequence', () {
      expect(csiChecker.isCupSequence("\x1b[24;1H"), isTrue);
      expect(csiChecker.isCupSequence("\x1b[34;47m"), isFalse);
    });
  });

  group('TestParametersExtractor', () {
    late ParametersExtractor paramsExtractor;

    setUp(() {
      paramsExtractor = ParametersExtractor();
    });

    test('test_extract_sgr', () {
      expect(paramsExtractor.extractSgr("\x1b[1;37m推"), equals([1, 37]));

      // default parameters
      expect(paramsExtractor.extractSgr("\x1b[m"), equals([0]));

      expect(
        () => paramsExtractor.extractSgr("Invalid Sequence"),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('test_extract_ed', () {
      expect(paramsExtractor.extractEd("\x1B[2J"), equals(2));

      // default parameters
      expect(paramsExtractor.extractEd("\x1b[J"), equals(0));

      expect(
        () => paramsExtractor.extractEd("Invalid Sequence"),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('test_extract_el', () {
      expect(paramsExtractor.extractEl("\x1B[2K"), equals(2));

      // default parameters
      expect(paramsExtractor.extractEl("\x1b[K"), equals(0));

      expect(
        () => paramsExtractor.extractEl("Invalid Sequence"),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('test_extract_cup', () {
      expect(paramsExtractor.extractCup("\x1b[24;1H"), equals([24, 1]));

      // default parameters
      expect(paramsExtractor.extractCup("\x1b[H"), equals([1, 1]));

      expect(
        () => paramsExtractor.extractCup("Invalid Sequence"),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
