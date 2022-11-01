import 'package:flutter/cupertino.dart';
import 'package:flutter_games/model/coordinate.dart';

import '../utils/bord_utils.dart';
import '../utils/generator.dart';
import 'box.dart';

@immutable
class Board {
  late List<List<Box>> labyrinth;
  late int nbRow;
  late int nbColumn;
  late Coordinate entryCoordinate;
  late Coordinate exitCoordinate;
  Board(this.labyrinth, this.nbRow, this.nbColumn);

  Board.full(this.nbRow, this.nbColumn) {
    labyrinth = List.generate(
        nbRow,
        (index) => List.generate(nbColumn,
            (_) => Box(isBottomSideWall: true, isLeftSideWall: true, isRightSideWall: true, isTopSideWall: true)));
  }
  Board.fromLength(this.nbRow, this.nbColumn) {
    labyrinth = List.generate(nbRow, (index) => List.generate(nbColumn, (_) => Box()));

    for (int i = 0; i < nbRow; i++) {
      labyrinth[i][0].isLeftSideWall = true;
      labyrinth[i][nbColumn - 1].isRightSideWall = true;
    }

    for (int j = 0; j < nbColumn; j++) {
      labyrinth[0][j].isTopSideWall = true;
      labyrinth[nbRow - 1][j].isBottomSideWall = true;
    }

    entryCoordinate = randomEntryCoordinate(nbRow, nbColumn);
    var isTopSideEntry = entryCoordinate.x == 0;
    if (isTopSideEntry) {
      labyrinth[entryCoordinate.x][entryCoordinate.y].isTopSideWall = false;
    } else {
      labyrinth[entryCoordinate.x][entryCoordinate.y].isLeftSideWall = false;
    }

    exitCoordinate = randomExitCoordinate(nbRow, nbColumn);
    var isBottomExit = exitCoordinate.x == nbRow - 1;
    if (isBottomExit) {
      labyrinth[exitCoordinate.x][exitCoordinate.y].isBottomSideWall = false;
    } else {
      labyrinth[exitCoordinate.x][exitCoordinate.y].isRightSideWall = false;
    }
    populateBoard(this);
  }

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
