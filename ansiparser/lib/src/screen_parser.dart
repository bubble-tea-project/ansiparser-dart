/*
ansiparser.screen_parser
~~~~~~~~~~~~~~

This module implements the parser that converts sequences into parsed_screen (a collection of InterConverted).
*/

import 'dart:collection';
import 'dart:core';

import './re_pattern.dart' as re_pattern;
import './converter.dart' as converter;
import './sequence_parser.dart' show SequenceParser;
import './sequence_utils.dart' show CSIChecker;
import './structures.dart';
import './utils.dart' as utils;

String applyBackspace(String string) {
  /// Apply backspace '\x08' to a string.
  List<String> result = [];
  for (var char in string.split('')) {
    if (char == '\b' && result.isNotEmpty) {
      result.removeLast();
    } else {
      result.add(char);
    }
  }
  return result.join('');
}

List<String> splitByAnsi(String string) {
  /// Split the string by ANSI escape sequences.

  return utils.splitWithDelimiters(string, re_pattern.ansiEscape);
}

class ScreenParser {
  Queue<List<String>> screenBuffer = Queue<List<String>>();

  List<InterConverted> currentParsedScreen = [];
  int currentLineIndex = 0;
  int currentIndex = 0;
  SgrAttributes currentSgrAttributes = SgrAttributes();

  final int screenHeight;
  final int screenWidth;

  bool lastScreenFinish = false;

  ScreenParser({this.screenHeight = 24, this.screenWidth = 80});

  List<String> _splitByEd(String string) {
    /// Split string by '\x1B[2J'(Erase in Display).
    return utils.splitWithDelimiters(
        string, re_pattern.eraseDisplayClearScreen);
  }

  List<String> _splitByNewline(String string) {
    return utils.splitWithDelimiters(string, RegExp(r'(\r\n|\n|\r)'));
  }

  String _parseStrOnly(bool peek) {
    /// Parse the string only; remove all ANSI sequences.
    if (screenBuffer.isEmpty) throw Exception("screen_buffer is empty");

    final rawScreen = peek ? screenBuffer.first : screenBuffer.removeFirst();
    final csiChecker = CSIChecker();

    var parsedString = '';
    for (final data in rawScreen) {
      final splitedSequences = splitByAnsi(data);
      for (final sequenceStr in splitedSequences) {
        if (!csiChecker.isCsi(sequenceStr)) {
          parsedString += sequenceStr;
        }
      }
    }
    return parsedString;
  }

  (InterConverted, List<InterConverted>) _parseLine(
      String rawLine, List<InterConverted> parsedScreen) {
    final csiChecker = CSIChecker();
    final sequenceParser = SequenceParser();

    InterConverted interConverted;
    if (currentLineIndex <= parsedScreen.length - 1) {
      interConverted = parsedScreen[currentLineIndex];
    } else {
      interConverted = InterConverted();
    }

    final splitedSequences = splitByAnsi(rawLine);
    for (var sequenceStr in splitedSequences) {
      // Select Graphic Rendition
      if (csiChecker.isSgrSequence(sequenceStr)) {
        currentSgrAttributes =
            sequenceParser.parseSgr(sequenceStr, currentSgrAttributes);
      }
      // Newline
      else if (sequenceStr == "\r\n" ||
          sequenceStr == "\n" ||
          sequenceStr == "\r") {
        final result = sequenceParser.parseNewline(sequenceStr, interConverted,
            currentIndex, parsedScreen, currentLineIndex);
        interConverted = result["interConverted"];
        currentIndex = result["currentIndex"];
        parsedScreen = result["parsedScreen"];
        currentLineIndex = result["currentLineIndex"];
      }
      // Text
      else if (!csiChecker.isCsi(sequenceStr)) {
        int tmpCurrentindex;
        (interConverted, tmpCurrentindex) = sequenceParser.parseText(
            sequenceStr, interConverted, currentSgrAttributes, currentIndex);
        this.currentIndex = tmpCurrentindex;
      }
      // Erase in Line
      else if (csiChecker.isElSequence(sequenceStr)) {
        interConverted =
            sequenceParser.parseEl(sequenceStr, interConverted, currentIndex);
      }
      // Erase in Display
      else if (csiChecker.isEdSequence(sequenceStr)) {
        (interConverted, parsedScreen) = sequenceParser.parseEd(sequenceStr,
            interConverted, currentIndex, parsedScreen, currentLineIndex);
      }
      // Cursor Position
      else if (csiChecker.isCupSequence(sequenceStr)) {
        final result = sequenceParser.parseCup(sequenceStr, interConverted,
            currentIndex, parsedScreen, currentLineIndex);
        interConverted = result["interConverted"];
        currentIndex = result["currentIndex"];
        parsedScreen = result["parsedScreen"];
        currentLineIndex = result["currentLineIndex"];
      }
    }
    return (interConverted, parsedScreen);
  }

  List<InterConverted> _parse({required bool peek}) {
    if (screenBuffer.isEmpty) throw Exception("screen_buffer is empty");

    List<String> rawScreen;
    List<InterConverted> parsedScreen;

    if (peek == true) {
      // Get the first element of the screen buffer without removing it
      rawScreen = screenBuffer.first;

      // Initialize parsedScreen as an empty list (equivalent to deque in Python)
      parsedScreen = [];
    } else {
      // Remove and get the first element from the screen buffer
      rawScreen = screenBuffer.removeFirst();

      // Create a copy of the current parsed screen (assuming it's a List)
      parsedScreen = currentParsedScreen.map((interConverted) {
        return interConverted.copy();
      }).toList();
    }

    final screenSplited = _splitByNewline(rawScreen.join(''));
    for (final rawLine in screenSplited) {
      InterConverted parsedLine = InterConverted();
      (parsedLine, parsedScreen) = _parseLine(rawLine, parsedScreen);

      if (currentLineIndex > parsedScreen.length - 1) {
        parsedScreen.add(parsedLine);
      } else {
        parsedScreen[currentLineIndex] = parsedLine;
      }

      // If parsedScreen length exceeds screenHeight, scroll (by removing the first line).
      if (parsedScreen.length > screenHeight) {
        parsedScreen.removeAt(0);
        currentLineIndex--;
      }
    }
    return parsedScreen;
  }

  void fromParsedScreen(List<InterConverted> parsedScreen) {
    /// Initialize from `parsed_screen`.
    if (parsedScreen.isEmpty) {
      throw Exception("parsedScreen is Empty");
    } else {
      currentParsedScreen = parsedScreen;
    }
  }

  Queue<List<String>>? buffer() {
    return screenBuffer.isEmpty ? null : screenBuffer;
  }

  void put(String string) {
    /// Add new strings to screen_buffer.
    var rawScreens = _splitByEd(applyBackspace(string));
    for (var rawScreen in rawScreens) {
      if (rawScreen == '\x1B[2J') {
        // Consider 'clear entire screen' as the finish.
        lastScreenFinish = true;
        screenBuffer.add([rawScreen]);
      } else if (lastScreenFinish || screenBuffer.isEmpty) {
        // Create a new screen if the last screen finishes or the buffer is empty.
        lastScreenFinish = false;
        screenBuffer.add([rawScreen]);
      } else {
        // Put to last screen.
        screenBuffer.last.add(rawScreen);
      }
    }
  }

  void parse() {
    /// Remove current screen_buffer and parse.
    if (screenBuffer.isNotEmpty) {
      currentParsedScreen = _parse(peek: false);
    }
  }

  bool full() {
    /// If the current parsed screen is full.
    return currentParsedScreen.length >= screenHeight;
  }

  void clear() {
    /// Clear current parsed_screen and index.
    currentParsedScreen = [];
    currentLineIndex = 0;
    currentIndex = 0;
  }

  bool finished() {
    /// If the current screen buffer is finished (encountered 'clear entire screen').
    return screenBuffer.length >= 2;
  }

  bool bufferEmpty() {
    /// If screen_buffer is empty.
    return screenBuffer.isEmpty;
  }

  void clearBuffer() {
    /// Clear screen_buffer.
    screenBuffer.clear();
  }

  void clearOldBuffer() {
    while (finished()) {
      screenBuffer.removeFirst();
    }
  }

  List<InterConverted> getParsedScreen() {
    /// Return underlying current `parsed_screen`.
    return currentParsedScreen
        .map((interConverted) => interConverted.copy())
        .toList();
  }

  String peekString() {
    return _parseStrOnly(true);
  }

  List<String> toFormattedString({bool peek = false}) {
    /// Convert the current `parsed_screen` to a formatted string.
    /// If `peek` is True, peek at the current buffer and convert it to a formatted string.
    var parsedScreen = peek ? _parse(peek: peek) : currentParsedScreen;
    return parsedScreen
        .map((parsedLine) => converter.toString(parsedLine))
        .toList();
  }

  List<String> toHtml({bool peek = false}) {
    /// Convert the current `parsed_screen` to HTML.
    /// If `peek` is True, peek at the current buffer and convert it to HTML.
    var parsedScreen = peek ? _parse(peek: peek) : currentParsedScreen;
    var htmlLines = parsedScreen
        .map((parsedLine) => converter.toHtml(parsedLine).outerHtml)
        .toList();
    return htmlLines;
  }
}
