/*
ansiparser.api
~~~~~~~~~~~~~~

This module implements the ansiparser API.
*/

import './screen_parser.dart';
import './structures.dart';


// Initialize the ScreenParser for a new screen.
ScreenParser newScreen({int height = 24, int width = 80}) {
  return ScreenParser(screenHeight: height, screenWidth: width);
}

// Initialize the ScreenParser from an existing parsed screen.
ScreenParser fromScreen(List<InterConverted> parsedScreen) {
  var screenParser = ScreenParser();
  screenParser.fromParsedScreen(parsedScreen);
  return screenParser;
}
