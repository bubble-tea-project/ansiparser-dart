import 'package:ansiparser/ansiparser.dart' as ansiparser;

void main() {
  final ansipScreen = ansiparser.newScreen();
  ansipScreen.put('\x1b[1;6H-World!\x1b[1;1HHello');

  ansipScreen.parse();
  final converted = ansipScreen.toFormattedString();

  print(converted); // ['Hello-World!']
}
