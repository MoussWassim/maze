// ignore_for_file: unnecessary_overrides
import 'package:flutter/material.dart';

@immutable
class Coordinate {
  final int x;
  final int y;

  const Coordinate({this.x = 0, this.y = 0});

  @override
  String toString() {
    return " ($x, $y) ";
  }

  @override
  bool operator ==(Object other) => other is Coordinate && other.x == x && other.y == y;

  @override
  int get hashCode => super.hashCode;
}
