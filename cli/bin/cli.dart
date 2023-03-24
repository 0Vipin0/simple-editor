import 'package:cli/editor.dart';
import 'package:dart_console/dart_console.dart';

void main(List<String> arguments) {
  final Console console = Console();
  final Editor editor = Editor(console: console);
  editor.init();
  if (arguments.isNotEmpty) {
    final String filename = arguments[0];
    editor.openFile(filename);
  }
  try {
    console.rawMode = true;
    while (true) {
      editor.scroll();
      editor.refresh();
      final Key key = console.readKey();
      editor.handleKey(key);
    }
  } catch (exception) {
    console.rawMode = false;
    rethrow;
  }
}
