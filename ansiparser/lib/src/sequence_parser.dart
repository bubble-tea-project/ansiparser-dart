/*
ansi_to_html.sequence_parser
~~~~~~~~~~~~~~~~~~~

This module implements the underlying parser that converts sequences to InterConverted.
*/

import './utils.dart' as utils;
import './structures.dart';
import './sequence_utils.dart' show ParametersExtractor;
import 'package:east_asian_width/east_asian_width.dart' as eaw;

SgrAttributes sgrParametersToAttributes(
    List<int> parameters, SgrAttributes sgrAttributes) {
  for (var parameter in parameters) {
    switch (parameter) {
      case 0:
        // Reset or normal
        sgrAttributes.clear();
        break;

      case (>= 1 && <= 9) || (>= 22 && <= 29):
        // font styles
        sgrAttributes.style.add(utils.sgrMap[parameter]!);
        break;

      case (>= 30 && <= 37) || (>= 90 && <= 97):
        // Set foreground color
        sgrAttributes.foreground = utils.sgrMap[parameter]!;
        break;

      case (>= 40 && <= 47) || (>= 100 && <= 107):
        // Set background color
        sgrAttributes.background = utils.sgrMap[parameter]!;
        break;

      default:
        throw UnimplementedError('Not supported yet, parameter=$parameter');
    }
  }

  return sgrAttributes;
}

class SequenceParser {
  SequenceParser();

  (InterConverted, int) _processChar(
      String char,
      String mode,
      InterConverted interConverted,
      SgrAttributes currentSgrAttributes,
      int currentIndex) {
    //
    if (!interConverted.validate()) {
      throw ArgumentError("interConverted is invalid.");
    }

    final wcharph = WCharPH();

    bool isCharWide(String char) {
      return ['W', 'F', 'A'].contains(eaw.eastAsianWidth(char).abbrev);
    }

    void wideReplaceNextChar() {
      if (currentIndex + 1 > interConverted.text.length - 1) {
        // index out of range
        interConverted.text.add(wcharph);
      } else {
        if (isCharWide(interConverted.text[currentIndex + 1].toString())) {
          // next char is wide
          utils.safeReplaceRange(interConverted.text, currentIndex + 1,
              currentIndex + 3, [wcharph, " "]);
        } else {
          interConverted.text[currentIndex + 1] = wcharph;
        }
      }
    }

    bool isNewWide = isCharWide(char);

    switch (mode) {
      case "add":
        if (isNewWide) {
          // new char is wide
          interConverted.text.addAll([char, wcharph]);
          interConverted.styles.addAll(List<SgrAttributes>.generate(
              2, (_) => currentSgrAttributes.copy()));

          return (
            interConverted,
            currentIndex + 2
          ); // +2 because a placeholder is appended
        } else {
          // new char is narrow
          interConverted.text.add(char);
          interConverted.styles.add(currentSgrAttributes.copy());

          return (
            interConverted,
            currentIndex + 1
          ); // +1 because a placeholder is not needed
        }

      case "overwrite":
        var currentChar = interConverted.text[currentIndex];

        if (isNewWide) {
          // new char is wide
          if (currentChar is WCharPH) {
            // currentChar is placeholder
            utils.safeReplaceRange(interConverted.text, currentIndex - 1,
                currentIndex + 1, [" ", char]);
            wideReplaceNextChar();

            utils.safeReplaceRange(
                interConverted.styles,
                currentIndex,
                currentIndex + 2,
                List.generate(2, (_) => currentSgrAttributes.copy()));
          } else if (isCharWide(currentChar.toString())) {
            // currentChar is wide
            interConverted.text[currentIndex] = char;
            utils.safeReplaceRange(
                interConverted.styles,
                currentIndex,
                currentIndex + 2,
                List.generate(2, (_) => currentSgrAttributes.copy()));
          } else {
            // currentChar is narrow
            interConverted.text[currentIndex] = char;
            wideReplaceNextChar();
            utils.safeReplaceRange(
                interConverted.styles,
                currentIndex,
                currentIndex + 2,
                List.generate(2, (_) => currentSgrAttributes.copy()));
          }

          return (
            interConverted,
            currentIndex + 2
          ); // +2 because a placeholder is appended
        } else {
          // new char is narrow
          if (currentChar is WCharPH) {
            // currentChar is placeholder
            utils.safeReplaceRange(interConverted.text, currentIndex - 1,
                currentIndex + 1, [" ", char]);

            interConverted.styles[currentIndex] = currentSgrAttributes.copy();
          } else if (isCharWide(currentChar.toString())) {
            // currentChar is wide
            utils.safeReplaceRange(interConverted.text, currentIndex,
                currentIndex + 2, [char, " "]);
            interConverted.styles[currentIndex] = currentSgrAttributes.copy();
          } else {
            // narrow
            interConverted.text[currentIndex] = char;
            interConverted.styles[currentIndex] = currentSgrAttributes.copy();
          }

          return (
            interConverted,
            currentIndex + 1
          ); // +1 because a placeholder is not needed
        }

      default:
        throw ArgumentError("Incorrect mode argument.");
    }
  }

  (InterConverted, int) parseText(
      String sequence,
      InterConverted interConverted,
      SgrAttributes currentSgrAttributes,
      int currentIndex) {
    // Fill empty spaces if the cursor is moved.
    int maxIndex = interConverted.text.length - 1;
    int need = currentIndex - maxIndex - 1;
    if (need > 0) {
      interConverted.text.addAll(List.filled(need, " ")); // space
      interConverted.styles
          .addAll(List<SgrAttributes>.generate(need, (_) => SgrAttributes()));
    }

    // process text
    List<String> charList = sequence.split('');
    for (String char in charList) {
      maxIndex = interConverted.text.length - 1;
      if (currentIndex > maxIndex) {
        // add new
        (interConverted, currentIndex) = _processChar(
             char,"add", interConverted, currentSgrAttributes, currentIndex);
      } else {
        // overwrite
        (interConverted, currentIndex) = _processChar( char,"overwrite",
            interConverted, currentSgrAttributes, currentIndex);
      }
    }

    return (interConverted, currentIndex);
  }

  SgrAttributes parseSgr(String sequence, SgrAttributes currentSgrAttributes) {
    ParametersExtractor extractor = ParametersExtractor();
    List<int> parameters = extractor.extractSgr(sequence);
    return sgrParametersToAttributes(parameters, currentSgrAttributes);
  }

  InterConverted parseEl(
      String sequence, InterConverted interConverted, int currentIndex) {
    var extracter = ParametersExtractor();
    var parameter = extracter.extractEl(sequence);

    switch (parameter) {
      case 0:
        // If n is 0, clear from cursor to the end of the line
        // include cursor char
        interConverted.text = interConverted.text.sublist(0, currentIndex);
        interConverted.styles = interConverted.styles.sublist(0, currentIndex);
        break;

      case 1:
        // If n is 1, clear from cursor to beginning of the line.
        // include cursor char
        var test = interConverted.text.runtimeType;
        interConverted.text.replaceRange(
            0, currentIndex + 1, List.generate(currentIndex + 1, (_) => " ")); // space
        interConverted.styles.replaceRange(0, currentIndex + 1,
            List.generate(currentIndex + 1, (_) => SgrAttributes()));
        break;

      case 2:
        // If n is 2, clear entire line.
        interConverted.clear();
        break;

      default:
        throw StateError("Invalid parameter.");
    }

    return interConverted;
  }

  (InterConverted, List<InterConverted>) parseEd(
      String sequence,
      InterConverted interConverted,
      int currentIndex,
      List<InterConverted> parsedScreen,
      int currentLineIndex) {
    var extracter = ParametersExtractor();
    var parameter = extracter.extractEd(sequence);

    switch (parameter) {
      case 0:
        // If n is 0 (or missing), clear from cursor to end of screen.
        // Cursor position does not change.
        parsedScreen = parsedScreen.sublist(0, currentLineIndex);
        interConverted.text = interConverted.text.sublist(0, currentIndex);
        interConverted.styles = interConverted.styles.sublist(0, currentIndex);
        break;

      case 1:
        // If n is 1, clear from cursor to beginning of the screen.
        parsedScreen.replaceRange(0, currentLineIndex + 1,
            List.generate(currentLineIndex + 1, (_) => InterConverted()));

        interConverted.text.replaceRange(
            0, currentIndex + 1, List.filled(currentIndex + 1, " "));
        // space
        interConverted.styles.replaceRange(0, currentIndex + 1,
            List.generate(currentIndex + 1, (_) => SgrAttributes()));
        break;

      case 2:
        // If n is 2, clear entire screen.
        parsedScreen.clear();
        interConverted.clear();
        break;

      default:
        throw StateError("Invalid parameter.");
    }

    return (interConverted, parsedScreen);
  }

  Map<String, dynamic> parseCup(
    String sequence,
    InterConverted interConverted,
    int currentIndex,
    List<InterConverted> parsedScreen,
    int currentLineIndex,
  ) {
    // Parse "Cursor Position" sequence.

    var extracter = ParametersExtractor();
    var parameter = extracter.extractCup(sequence);

    // Moves the cursor to row n, column m. The values are 1-based.
    int nextLineIndex = parameter[0] - 1;
    int nextIndex = parameter[1] - 1;

    // Append current line to screen.
    int maxLineIndex = parsedScreen.length - 1;
    if (currentLineIndex > maxLineIndex) {
      // Add new
      parsedScreen.add(interConverted.copy());
    } else {
      // Overwrite
      parsedScreen[currentLineIndex] = interConverted.copy();
    }

    // Fill empty lines (including current).
    maxLineIndex = parsedScreen.length - 1;
    int need = nextLineIndex - maxLineIndex;
    if (need > 0) {
      // Create independent InterConverted instances.
      parsedScreen
          .addAll(List<InterConverted>.generate(need, (_) => InterConverted()));
    }

    // Move cursor to nextLineIndex.
    interConverted = parsedScreen[nextLineIndex];

    currentIndex = nextIndex;
    currentLineIndex = nextLineIndex;

    return {
      "interConverted": interConverted,
      "currentIndex": currentIndex,
      "parsedScreen": parsedScreen,
      "currentLineIndex": currentLineIndex,
    };
  }

  Map<String, dynamic> parseNewline(
    String sequence,
    InterConverted interConverted,
    int currentIndex,
    List<InterConverted> parsedScreen,
    int currentLineIndex,
  ) {
    // Parse "newline("\r\n", "\n", "\r")" sequence.

    if (sequence != "\r\n" && sequence != "\n" && sequence != "\r") {
      throw ArgumentError("Invalid newline sequence.");
    }

    if (sequence == "\r") {
      // Carriage Return
      // Moves the cursor to the beginning of the line without advancing to the next line
      currentIndex = 0;
    } else {
      int nextLineIndex = currentLineIndex + 1;

      // Fill empty lines (including current).
      int maxLineIndex = parsedScreen.length - 1;
      int need = nextLineIndex - maxLineIndex;
      if (need > 0) {
        // Create independent InterConverted objects
        parsedScreen.addAll(
            List<InterConverted>.generate(need, (_) => InterConverted()));
      }

      // Move cursor to nextLineIndex
      interConverted = parsedScreen[nextLineIndex];

      // Moves the cursor to the next row.
      currentLineIndex = nextLineIndex;

      // "\r\n" as Carriage Return + Line Feed
      // Moves the cursor to the beginning and moves the cursor down to the next line
      if (sequence == "\r\n") {
        currentIndex = 0;
      }

      // Line Feed (moves the cursor down to the next line without returning to the beginning)
      // "currentIndex" does not change in this case.
    }

    return {
      "interConverted": interConverted,
      "currentIndex": currentIndex,
      "parsedScreen": parsedScreen,
      "currentLineIndex": currentLineIndex,
    };
  }
}
