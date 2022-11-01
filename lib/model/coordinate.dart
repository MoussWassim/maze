// ignore_for_file: unnecessary_overrides

class Coordinate {
  late int x;
  late int y;

  Coordinate({this.x = 0, this.y = 0});

  @override
  String toString() {
    return " ($x, $y) ";
  }

  @override
  bool operator ==(Object other) => other is Coordinate && other.x == x && other.y == y;

  @override
  int get hashCode => super.hashCode;
}
