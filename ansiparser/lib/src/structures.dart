/// ansiparser.structures
/// ----------
///
/// Data structures used in ansiparser.
library;

import 'package:collection/collection.dart';

/// Placeholder for wide characters.
class WCharPH {}

/// A class to represent the SGR (Select Graphic Rendition) attributes for text formatting.
class SgrAttributes {
  Set<String> style = {};
  String background = '';
  String foreground = '';

  @override
  bool operator ==(Object other) {
    if (other is SgrAttributes) {
      return DeepCollectionEquality().equals(style, other.style) &&
          background == other.background &&
          foreground == other.foreground;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(style, background, foreground);

  /// Create a deep copy
  SgrAttributes copy() {
    SgrAttributes copyInstance = SgrAttributes();

    // Shallow copy for Set<String> (String is immutable objects)
    copyInstance.style = Set.of(this.style);

    copyInstance.background = this.background;
    copyInstance.foreground = this.foreground;

    return copyInstance;
  }

  /// Remove all elements from the SgrAttributes.
  void clear() {
    style.clear();
    background = '';
    foreground = '';
  }

  /// Return true if all elements are empty, otherwise return false.
  bool empty() {
    return style.isEmpty && background.isEmpty && foreground.isEmpty;
  }
}

/// Single-line intermediate conversion of ANSI escape codes.
class InterConverted {
  /// Contains `String` or `WCharPH` elements.
  List<Object> text = [];

  List<SgrAttributes> styles = [];

  /// Create a deep copy
  InterConverted copy() {
    InterConverted copyInstance = InterConverted();

    // Shallow copy for text (String is immutable objects and WCharPH is placeholder)
    copyInstance.text = List<Object>.of(this.text);

    // Deep copy styles
    copyInstance.styles = this.styles.map((style) {
      return style.copy();
    }).toList();

    return copyInstance;
  }

  /// Remove all elements from the InterConverted.
  void clear() {
    text.clear();
    styles.clear();
  }

  /// Return True if the InterConverted is empty, False otherwise.
  bool empty() {
    return text.isEmpty && styles.isEmpty;
  }

  /// Return True if the text and styles in InterConverted have the same length; otherwise, return False.
  bool validate() {
    return text.length == styles.length;
  }
}
