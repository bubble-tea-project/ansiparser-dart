import 'package:test/test.dart';

import 'package:ansiparser/src/re_pattern.dart';

void main() {
  test('test_ansi_escape', () {
    expect(ansiEscape.hasMatch("\x1b[1;6H-World!\x1b[1;1HHello"), isTrue);
    expect(ansiEscape.hasMatch("No ANSI escape"), isFalse);
  });

  test('test_csi_sequence', () {
    expect(csiSequence.hasMatch("\x1b[1;6H-World!\x1b[1;1HHello"), isTrue);
    expect(csiSequence.hasMatch("Not a CSI sequence"), isFalse);
  });

  test('test_sgr_sequence', () {
    expect(sgrSequence.hasMatch("\x1b[1;37m推"), isTrue);
    expect(sgrSequence.hasMatch("\x1b[1;6H-World"), isFalse);
  });

  test('test_erase_display_sequence', () {
    expect(eraseDisplaySequence.hasMatch("\x1B[1J"), isTrue);
    expect(eraseDisplaySequence.hasMatch("\x1B[2K"), isFalse);
  });

  test('test_erase_display_clear_screen', () {
    expect(eraseDisplayClearScreen.hasMatch("\x1B[2J"), isTrue);
    expect(eraseDisplayClearScreen.hasMatch("\x1B[1J"), isFalse);
  });

  test('test_erase_line_sequence', () {
    expect(eraseLineSequence.hasMatch("\x1B[2K"), isTrue);
    expect(eraseLineSequence.hasMatch("\x1B[1J"), isFalse);
  });

  test('test_cursor_position_sequence', () {
    expect(cursorPositionSequence.hasMatch("\x1b[24;1H"), isTrue);
    expect(cursorPositionSequence.hasMatch("\x1b[34;47m"), isFalse);
  });
}
