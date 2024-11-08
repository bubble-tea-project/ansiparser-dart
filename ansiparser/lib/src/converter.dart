/// ansiparser.converter
/// ----------
///
/// This module provides a converter to convert InterConverted to HTML or string.
library;

import 'package:html/dom.dart' as html_dom;

import './structures.dart';

/// Convert SGR attributes to CSS class.
String sgrAttributesToCss(SgrAttributes sgrAttributes) {
  final fontStyles = sgrAttributes.style.join(' ');
  final colorForeground = sgrAttributes.foreground;
  final colorBackground = sgrAttributes.background;

  final cssClass = [fontStyles, colorForeground, colorBackground];

  // Removes redundant spaces.
  return cssClass.where((s) => s.isNotEmpty).join(' ');
}

/// Convert InterConverted to HTML
html_dom.Element toHtml(InterConverted interConverted,
    {bool placeholder = false}) {
  //
  if (!interConverted.validate()) {
    throw ArgumentError("interConverted is invalid.");
  }

  final lineDiv = html_dom.Element.tag('div');
  lineDiv.classes.add('line');

  // If empty, treat as a newline.
  if (interConverted.empty()) {
    final newlineDiv = html_dom.Element.tag('br');
    newlineDiv.classes.add('line');

    return newlineDiv;
  }

  // Process placeholders for wide characters.
  final filteredChar = <String>[];
  final filteredStyle = <SgrAttributes>[];

  for (var index = 0; index < interConverted.text.length; index++) {
    final item = interConverted.text[index];

    // if ignore placeholder
    if (item is WCharPH && placeholder) {
      // replace placeholders with spaces
      filteredChar.add(" ");
      filteredStyle.add(interConverted.styles[index]);
    } else if (item is! WCharPH) {
      filteredChar.add(item.toString());
      filteredStyle.add(interConverted.styles[index]);
    }
  }

  // Convert
  final lineString = filteredChar.join('');
  var lastStyle = filteredStyle[0];

  var startIndex = 0;
  var currentIndex = 0;

  for (var style in filteredStyle) {
    // Until a different style is encountered.
    if (lastStyle != style) {
      final tmpSpan = html_dom.Element.tag('span');
      tmpSpan.classes.add(sgrAttributesToCss(lastStyle));
      tmpSpan.text = lineString.substring(startIndex, currentIndex);

      lineDiv.append(tmpSpan);

      startIndex += tmpSpan.text.length;
    }

    lastStyle = style;
    currentIndex++;
  }

  // Last element
  final tmpSpan = html_dom.Element.tag('span');
  tmpSpan.classes.add(sgrAttributesToCss(lastStyle));
  tmpSpan.text = lineString.substring(startIndex, currentIndex);

  lineDiv.append(tmpSpan);

  return lineDiv;
}

/// Convert InterConverted to string
String toString(InterConverted interConverted, {bool placeholder = false}) {
  //
  if (!interConverted.validate()) {
    throw ArgumentError("interConverted is invalid.");
  }

  // If empty, treat as a newline.
  if (interConverted.empty()) {
    return "";
  }

  // Process placeholders for wide characters.
  final filteredChar = <String>[];

  for (final item in interConverted.text) {
    // if ignore placeholder
    if (item is WCharPH && placeholder) {
      // replace placeholders with spaces
      filteredChar.add(" ");
    } else if (item is! WCharPH) {
      filteredChar.add(item.toString());
    }
  }

  return filteredChar.join('');
}
