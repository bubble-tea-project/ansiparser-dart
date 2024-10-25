/*
ansiparser.sequence_utils
~~~~~~~~~~~~~~

This module provides functions to check CSI sequences and extract their parameters.
*/

import './re_pattern.dart' as re_pattern;

class CSIChecker {
  CSIChecker();

  bool _isRegexMatch(RegExp regex, String string) {
    return regex.hasMatch(string);
  }

  bool isCsi(String string) {
    // Return true if the string is "CSI (Control Sequence Introducer)" sequences.
    return _isRegexMatch(re_pattern.csiSequence, string);
  }

  bool isSgrSequence(String string) {
    // Return true if the string is "SGR (Select Graphic Rendition)" sequences.
    return _isRegexMatch(re_pattern.sgrSequence, string);
  }

  bool isEdSequence(String string) {
    // Return true if the string is "Erase in Display" sequences.
    return _isRegexMatch(re_pattern.eraseDisplaySequence, string);
  }

  bool isElSequence(String string) {
    // Return true if the string is "Erase in Line" sequences.
    return _isRegexMatch(re_pattern.eraseLineSequence, string);
  }

  bool isCupSequence(String string) {
    // Return true if the string is "Cursor Position" sequences.
    return _isRegexMatch(re_pattern.cursorPositionSequence, string);
  }
}

class ParametersExtractor {
  ParametersExtractor();

  List<int> extractSgr(String sequence) {
    // Extract parameters for "SGR (Select Graphic Rendition)" sequences.
    final match = re_pattern.sgrSequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "SGR (Select Graphic Rendition)" sequences.');
    }

    final parametersStr = match.group(1) ?? '';
    if (parametersStr.isEmpty) {
      // CSI m is treated as CSI 0 m (reset / normal).
      return [0];
    } else {
      return parametersStr.split(';').map(int.parse).toList();
    }
  }

  int extractEd(String sequence) {
    // Extract parameters for "Erase in Display" sequences.
    final match = re_pattern.eraseDisplaySequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "Erase in Display" sequences.');
    }

    final parametersStr = match.group(1) ?? '';
    return parametersStr.isEmpty ? 0 : int.parse(parametersStr);
  }

  int extractEl(String sequence) {
    // Extract parameters for "Erase in Line" sequences.
    final match = re_pattern.eraseLineSequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "Erase in Line" sequences.');
    }

    final parametersStr = match.group(1) ?? '';
    return parametersStr.isEmpty ? 0 : int.parse(parametersStr);
  }

  List<int> extractCup(String sequence) {
    // Extract parameters for "Cursor Position" sequences.
    final match = re_pattern.cursorPositionSequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "Cursor Position" sequences.');
    }

    final parametersStr = match.group(1) ?? '';
    if (parametersStr.isEmpty) {
      // [H as [1;1H
      return [1, 1];
    } else {
      final results = parametersStr.split(';');
      if (results.length != 2) {
        throw ArgumentError("Position parameters error.");
      }

      // The values are 1-based, and default to 1 (top left corner) if omitted.
      results[0] = results[0].isEmpty ? '1' : results[0];
      results[1] = results[1].isEmpty ? '1' : results[1];

      return results.map(int.parse).toList();
    }
  }
}
