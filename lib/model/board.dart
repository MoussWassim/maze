import 'package:flutter_games/model/coordinate.dart';

import 'box.dart';

class Board {
  late List<List<Box>> labyrinth;
  late int nbRow;
  late int nbColumn;
  late Coordinate entryCoordinate;
  late Coordinate exitCoordinate;

  Board({
    required this.labyrinth,
    required this.nbRow,
    required this.nbColumn,
    required this.entryCoordinate,
    required this.exitCoordinate,
  });

  isEdgeBox(int xAxis, int yAxis) {
    return xAxis == 0 || xAxis == nbRow - 1 || yAxis == 0 || yAxis == nbColumn - 1;
  }

  isExitEdgeBox(int xAxis, int yAxis) {
    return xAxis == nbRow - 1 || yAxis == nbColumn - 1;
  }

  bool isExitBox(int xAxis, int yAxis) =>
      yAxis == nbColumn - 1 && !labyrinth[xAxis][yAxis].isRightSideWall ||
      xAxis == nbRow - 1 && !labyrinth[xAxis][yAxis].isBottomSideWall;

  bool isEntryBox(int xAxis, int yAxis) =>
      isEdgeBox(xAxis, yAxis) && (!labyrinth[xAxis][yAxis].isLeftSideWall || !labyrinth[xAxis][yAxis].isRightSideWall);

  getBox(Coordinate starting) {
    return labyrinth[starting.x][starting.y];
  }
}
