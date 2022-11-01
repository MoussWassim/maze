import 'dart:math';

import 'package:flutter_games/model/board.dart';

populateBoard(Board board) {
  for (int i = 0; i < board.nbRow; i++) {
    for (int j = 0; j < board.nbColumn - 1; j++) {
      var nextBool = Random().nextBool();
      board.labyrinth[i][j].isRightSideWall = nextBool;
      board.labyrinth[i][j + 1].isLeftSideWall = nextBool;
    }
  }

  for (int j = 0; j < board.nbColumn; j++) {
    for (int i = 0; i < board.nbRow - 1; i++) {
      var nextBool = Random().nextBool();
      board.labyrinth[i][j].isBottomSideWall = nextBool;
      board.labyrinth[i + 1][j].isTopSideWall = nextBool;
    }
  }
}
