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

  final CursorCoordinate coordinate = CursorCoordinate(x: 0, y: 0);

  void init() {
    columns = console.windowWidth;
    rows = console.windowHeight;
  }

  void refresh() {
    console.clearScreen();
    console.resetCursorPosition();

    for (int i = 0; i < rows - 1; i++) {
      console.write("~\r\n");
    }
    console.setBackgroundColor(ConsoleColor.white);
    console.setForegroundColor(ConsoleColor.black);
    console.write(statusMessage);
    for (int i = 0; i < max(0, columns - statusMessage.length); i++) {
      console.write(" ");
    }
    console.setBackgroundColor(ConsoleColor.black);
    console.setForegroundColor(ConsoleColor.white);
    console.cursorPosition = Coordinate(coordinate.y, coordinate.x);
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
        if (coordinate.y < rows - 2) {
          coordinate.y++;
        }
        break;
      case ControlCharacter.arrowLeft:
        if (coordinate.x > 0) {
          coordinate.x--;
        }
        break;
      case ControlCharacter.arrowRight:
        if (coordinate.x < columns - 2) {
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
}
