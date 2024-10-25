/*
ansiparser.converter
~~~~~~~~~~~~~~

This module provides a converter to convert InterConverted to HTML or string.
*/

import 'package:html/dom.dart' as html;

import 'structures.dart';


String sgrAttributesToCss(SgrAttributes sgrAttributes) {
  // Convert SGR attributes to CSS class.
  final fontStyles = sgrAttributes.style.join(' ');
  final colorForeground = sgrAttributes.foreground;
  final colorBackground = sgrAttributes.background;

  final cssClass = [fontStyles, colorForeground, colorBackground];

  // Removes redundant spaces.
  return cssClass.where((s) => s.isNotEmpty).join(' ');
}

html.Element toHtml(InterConverted interConverted, {bool placeholder = false}) {
  // Convert InterConverted to HTML

  if (!interConverted.validate()) {
    throw ArgumentError("interConverted is invalid.");
  }

  final lineDiv = html.Element.tag('div');
  lineDiv.classes.add('line');

  // If empty, treat as a newline.
  if (interConverted.empty()) {
    final newlineDiv = html.Element.tag('br');
    newlineDiv.classes.add('line');

    return newlineDiv;
  }

  // Process placeholders for wide characters.
  final filteredChar = <String>[];
  final filteredStyle = <SgrAttributes>[];

  for (var index = 0; index < interConverted.text.length; index++) {
    final item = interConverted.text[index];

    // if ignore placeholder
    if (item is WCharPH && placeholder == true) {
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
      final tmpSpan = html.Element.tag('span');
      tmpSpan.classes.add(sgrAttributesToCss(lastStyle));
      tmpSpan.text = lineString.substring(startIndex, currentIndex);

      lineDiv.append(tmpSpan);

      startIndex += tmpSpan.text.length;
    }

    lastStyle = style;
    currentIndex++;
  }

  // Last element
  final tmpSpan = html.Element.tag('span');
  tmpSpan.classes.add(sgrAttributesToCss(lastStyle));
  tmpSpan.text = lineString.substring(startIndex, currentIndex);

  lineDiv.append(tmpSpan);
  
  return lineDiv;
}

String toString(InterConverted interConverted, {bool placeholder = false}) {
  // Convert InterConverted to string

  if (!interConverted.validate()) {
    throw ArgumentError("interConverted is invalid.");
  }

  // If empty, treat as a newline.
  if (interConverted.empty()) {
    return "";
  }

  // Process placeholders for wide characters.
  final filteredChar = <String>[];

  for (var item in interConverted.text) {
    // if ignore placeholder
    if (item is WCharPH && placeholder == true) {
      // replace placeholders with spaces
      filteredChar.add(" ");
    } else if (item is! WCharPH) {
      filteredChar.add(item.toString());
    }
  }

  return filteredChar.join('');
}
