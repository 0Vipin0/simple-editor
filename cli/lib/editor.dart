import 'dart:io';
import 'dart:math';

import 'package:cli/cursor_coordinate.dart';
import 'package:dart_console/dart_console.dart';

import 'config.dart';

class Editor {
  final Console console;

  Editor({required this.console});

  int rows = 0;
  int columns = 0;
  int offsetY = 0;
  List<String> content = [];

  final CursorCoordinate coordinate = CursorCoordinate(x: 0, y: 0);

  void init() {
    columns = console.windowWidth;
    rows = console.windowHeight - 1;
  }

  void refresh() {
    console.clearScreen();
    console.resetCursorPosition();
    writeContent();
    console.setTextStyle(inverted: true);
    writeStatusBar();
    console.setTextStyle();
    console.cursorPosition = Coordinate(coordinate.y - offsetY, coordinate.x);
  }

  void writeStatusBar() {
    console.write(coordinate);
    for (int i = 0; i < max(0, columns - coordinate.toString().length); i++) {
      console.write(" ");
    }
  }

  void writeContent() {
    for (int i = 0; i < rows; i++) {
      final int fileCoordinateY = offsetY + i;
      if (fileCoordinateY >= content.length) {
        console.write("~");
      } else {
        console.write(content[fileCoordinateY]);
      }
      console.write("\r\n");
    }
  }

  void handleKey(Key key) {
    if (key.char == 'q') {
      exit(1);
    } else if (List.of([
      ControlCharacter.arrowUp,
      ControlCharacter.arrowDown,
      ControlCharacter.arrowLeft,
      ControlCharacter.arrowRight,
      ControlCharacter.home,
      ControlCharacter.end,
    ]).contains(key.controlChar)) {
      moveCursor(key);
    }
  }

  void moveCursor(Key key) {
    switch (key.controlChar) {
      case ControlCharacter.arrowUp:
        if (coordinate.y > 0) {
          coordinate.y--;
        }
        break;
      case ControlCharacter.arrowDown:
        if (coordinate.y < content.length) {
          coordinate.y++;
        }
        break;
      case ControlCharacter.arrowLeft:
        if (coordinate.x > 0) {
          coordinate.x--;
        }
        break;
      case ControlCharacter.arrowRight:
        if (coordinate.x < columns - 1) {
          coordinate.x++;
        }
        break;
      case ControlCharacter.home:
        coordinate.x = 0;
        break;
      case ControlCharacter.end:
        coordinate.x = columns - 1;
        break;
      default:
    }
  }

  void openFile(String filename) {
    final File file = File(filename);
    try {
      content = file.readAsLinesSync();
    } on FileSystemException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  void scroll() {
    if (coordinate.y >= offsetY + rows) {
      offsetY = coordinate.y - rows;
    } else if (coordinate.y < offsetY) {
      offsetY = coordinate.y;
    }
  }
}
