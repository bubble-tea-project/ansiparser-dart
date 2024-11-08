/// ansiparser.sequence_utils
/// ----------
///
/// This module provides functions to check CSI sequences and extract their parameters.
library;

import './re_pattern.dart' as re_pattern;

class CSIChecker {
  /// Return true if the string is "CSI (Control Sequence Introducer)" sequences.
  bool isCsi(String string) {
    return re_pattern.csiSequence.hasMatch(string);
  }

  /// Return true if the string is "SGR (Select Graphic Rendition)" sequences.
  bool isSgrSequence(String string) {
    return re_pattern.sgrSequence.hasMatch(string);
  }

  /// Return true if the string is "Erase in Display" sequences.
  bool isEdSequence(String string) {
    return re_pattern.eraseDisplaySequence.hasMatch(string);
  }

  /// Return true if the string is "Erase in Line" sequences.
  bool isElSequence(String string) {
    return re_pattern.eraseLineSequence.hasMatch(string);
  }

  /// Return true if the string is "Cursor Position" sequences.
  bool isCupSequence(String string) {
    return re_pattern.cursorPositionSequence.hasMatch(string);
  }
}

class ParametersExtractor {
  /// Extract parameters for "SGR (Select Graphic Rendition)" sequences.
  List<int> extractSgr(String sequence) {
    //
    final match = re_pattern.sgrSequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "SGR (Select Graphic Rendition)" sequences.');
    }

    final parametersStr = match.group(1)!;
    if (parametersStr.isEmpty) {
      // CSI m is treated as CSI 0 m (reset / normal).
      return [0];
    } else {
      return parametersStr.split(';').map(int.parse).toList();
    }
  }

  /// Extract parameters for "Erase in Display" sequences.
  int extractEd(String sequence) {
    //
    final match = re_pattern.eraseDisplaySequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "Erase in Display" sequences.');
    }

    final parametersStr = match.group(1)!;
    if (parametersStr.isEmpty) {
      // [J as [0J
      return 0;
    } else {
      return int.parse(parametersStr);
    }
  }

  /// Extract parameters for "Erase in Line" sequences.
  int extractEl(String sequence) {
    //
    final match = re_pattern.eraseLineSequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "Erase in Line" sequences.');
    }

    final parametersStr = match.group(1)!;
    if (parametersStr.isEmpty) {
      // [K as [0K
      return 0;
    } else {
      return int.parse(parametersStr);
    }
  }

  /// Extract parameters for "Cursor Position" sequences.
  List<int> extractCup(String sequence) {
    //
    final match = re_pattern.cursorPositionSequence.firstMatch(sequence);
    if (match == null) {
      throw ArgumentError('Not "Cursor Position" sequences.');
    }

    final parametersStr = match.group(1)!;
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
