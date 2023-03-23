class CursorCoordinate {
  int x;
  int y;

  CursorCoordinate({required this.x, required this.y});

  @override
  String toString() {
    return 'CursorCoordinate{x: $x, y: $y}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CursorCoordinate &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
