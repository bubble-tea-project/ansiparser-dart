import 'package:test/test.dart';
import 'package:ansiparser/src/sequence_utils.dart';
import 'package:ansiparser/src/re_pattern.dart';

void main() {
  // Sample strings to test against the patterns
  const sampleString = "Hello World";
  const sampleAnsiString = "\x1b[1;6H-World!\x1b[1;1HHello";
  const sampleSgrString = "\x1b[1;37m推";
  const sampleEraseDisplay = "\x1B[2J";
  const sampleEraseLine = "\x1B[2K";
  const sampleCursorPosition = "\x1b[24;1H";

  group('CSIChecker Tests', () {
    final csiChecker = CSIChecker();

    test('testIsCsi', () {
      expect(csiChecker.isCsi(sampleAnsiString), isTrue);
      expect(csiChecker.isCsi(sampleString), isFalse);
    });

    test('testIsSgrSequence', () {
      expect(csiChecker.isSgrSequence(sampleSgrString), isTrue);
      expect(csiChecker.isSgrSequence(sampleString), isFalse);
    });

    test('testIsEdSequence', () {
      expect(csiChecker.isEdSequence(sampleEraseDisplay), isTrue);
      expect(csiChecker.isEdSequence(sampleEraseLine), isFalse);
    });

    test('testIsElSequence', () {
      expect(csiChecker.isElSequence(sampleEraseLine), isTrue);
      expect(csiChecker.isElSequence(sampleEraseDisplay), isFalse);
    });

    test('testIsCupSequence', () {
      expect(csiChecker.isCupSequence(sampleCursorPosition), isTrue);
      expect(csiChecker.isCupSequence(sampleSgrString), isFalse);
    });
  });

  group('ParametersExtractor Tests', () {
    final paramsExtractor = ParametersExtractor();

    test('testExtractSgr', () {
      expect(paramsExtractor.extractSgr(sampleSgrString), equals([1, 37]));

      const validSgrReset = "\x1b[m";
      expect(paramsExtractor.extractSgr(validSgrReset), equals([0]));

      expect(() => paramsExtractor.extractSgr("Invalid Sequence"),
          throwsA(isA<ArgumentError>()));
    });

    test('testExtractEd', () {
      expect(paramsExtractor.extractEd(sampleEraseDisplay), equals(2));

      const validEdNoParam = "\x1b[J";
      expect(paramsExtractor.extractEd(validEdNoParam), equals(0));

      expect(() => paramsExtractor.extractEd("Invalid Sequence"),
          throwsA(isA<ArgumentError>()));
    });

    test('testExtractEl', () {
      expect(paramsExtractor.extractEl(sampleEraseLine), equals(2));

      const validElNoParam = "\x1b[K";
      expect(paramsExtractor.extractEl(validElNoParam), equals(0));

      expect(() => paramsExtractor.extractEl("Invalid Sequence"),
          throwsA(isA<ArgumentError>()));
    });

    test('testExtractCup', () {
      expect(paramsExtractor.extractCup(sampleCursorPosition), equals([24, 1]));

      const validCupNoParam = "\x1b[H";
      expect(paramsExtractor.extractCup(validCupNoParam), equals([1, 1]));

      expect(() => paramsExtractor.extractCup("Invalid Sequence"),
          throwsA(isA<ArgumentError>()));
    });
  });
}
