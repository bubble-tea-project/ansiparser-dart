/*
ansiparser.structures
~~~~~~~~~~~~~~~~~~~

Data structures used in ansiparser.
*/

import 'package:collection/collection.dart';


class WCharPH {
  // Placeholder for wide characters.
  WCharPH();
}

class SgrAttributes {
  // A class to represent the SGR (Select Graphic Rendition) attributes for text formatting.

  Set<String> style = {};
  String background = '';
  String foreground = '';

  SgrAttributes();

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

  SgrAttributes copy() {
    // Deep copy

    SgrAttributes copyInstance = SgrAttributes();

    // Shallow copy for Set<String> (String is immutable objects)
    copyInstance.style = Set.of(this.style);

    copyInstance.background = this.background;
    copyInstance.foreground = this.foreground;

    return copyInstance;
  }

  void clear() {
    // Remove all elements from the SgrAttributes.
    style.clear();
    background = '';
    foreground = '';
  }

  bool empty() {
    // Return true if all elements are empty, otherwise return false.
    return style.isEmpty && background.isEmpty && foreground.isEmpty;
  }
}

class InterConverted {
  // Single-line intermediate conversion of ANSI escape codes.

  List<Object> text = [];
  List<SgrAttributes> styles = [];

  InterConverted();

  InterConverted copy() {
    // Method to create a deep copy of the InterConverted instance

    InterConverted copyInstance = InterConverted();

    // Shallow copy for text (String is immutable objects and WCharPH no data)
    copyInstance.text = List<Object>.of(this.text);

    // Deep copy styles
    copyInstance.styles = this.styles.map((style) {
      return style.copy();
    }).toList();

    return copyInstance;
  }

  void clear() {
    // Remove all elements from the InterConverted.
    text.clear();
    styles.clear();
  }

  bool empty() {
    // Return true if the InterConverted is empty, otherwise return false.
    return text.isEmpty && styles.isEmpty;
  }

  bool validate() {
    // Return true if the text and styles in InterConverted have the same length; otherwise, return false.
    return text.length == styles.length;
  }
}
