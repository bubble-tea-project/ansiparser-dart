/*
ansiparser.re_pattern
~~~~~~~~~~~~

This module implements commonly used regular expression patterns for ansiparser.
*/


// ANSI escape sequences
final RegExp ansiEscape = RegExp(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])');

// CSI (Control Sequence Introducer) sequences
final RegExp csiSequence = RegExp(r'\x1B(?:\[[0-?]*[ -/]*[@-~])');

// SGR (Select Graphic Rendition)
final RegExp sgrSequence = RegExp(r'\x1B(?:\[([\d;]*)m)');

// Erase in Display
final RegExp eraseDisplaySequence = RegExp(r'\x1B(?:\[([\d;]*)J)');

// Erase in Display - clear entire screen
final RegExp eraseDisplayClearScreen = RegExp(r'\x1B(?:\[2J)');

// Erase in Line
final RegExp eraseLineSequence = RegExp(r'\x1B(?:\[([\d;]*)K)');

// Cursor Position
final RegExp cursorPositionSequence = RegExp(r'\x1B(?:\[([\d;]*)H)');
