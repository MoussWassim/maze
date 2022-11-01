import 'package:flutter_games/model/board.dart';
import 'package:flutter_games/model/coordinate.dart';

import '../model/box.dart';

class SolutionUtils {
  List<Coordinate> getOneSolution(Board board, Coordinate starting) {
    List<Coordinate> solution = [];
    var entryBox = board.labyrinth[board.entryCoordinate.x][board.entryCoordinate.y];
    var comingFrom = !entryBox.isTopSideWall ? Direction.top : Direction.left;
    _getOneSolutionRecursive(board, starting, solution, comingFrom);
    solution.add(starting);
    solution = solution.reversed.toList();
    return solution;
  }

  _getOneSolutionRecursive(Board board, Coordinate starting, List<Coordinate> partielSolition, Direction comingFrom) {
    Box box = board.getBox(starting);

    if (board.isExitBox(starting.x, starting.y)) {
      return true;
    }
    if (comingFrom == Direction.left && box.isRightSideWall && box.isTopSideWall && box.isBottomSideWall) {
      return false;
    } else if (comingFrom == Direction.right && box.isLeftSideWall && box.isTopSideWall && box.isBottomSideWall) {
      return false;
    } else if (comingFrom == Direction.top && box.isRightSideWall && box.isLeftSideWall && box.isBottomSideWall) {
      return false;
    } else if (comingFrom == Direction.bottom && box.isRightSideWall && box.isTopSideWall && box.isLeftSideWall) {
      return false;
    }

    //go right tiil stop
    var nextStarting = Coordinate(x: starting.x, y: starting.y + 1);
    if (!box.isRightSideWall &&
        comingFrom != Direction.right &&
        _getOneSolutionRecursive(board, nextStarting, partielSolition, Direction.left)) {
      partielSolition.add(nextStarting);
      return true;
    }
    // go left till stop
    nextStarting = Coordinate(x: starting.x, y: starting.y - 1);
    if (!box.isLeftSideWall &&
        comingFrom != Direction.left &&
        _getOneSolutionRecursive(board, nextStarting, partielSolition, Direction.right)) {
      partielSolition.add(nextStarting);
      return true;
    }

    //go down till stop
    nextStarting = Coordinate(x: starting.x - 1, y: starting.y);
    if (!box.isTopSideWall &&
        comingFrom != Direction.top &&
        _getOneSolutionRecursive(board, nextStarting, partielSolition, Direction.bottom)) {
      partielSolition.add(nextStarting);
      return true;
    }

    //go up till stop
    nextStarting = Coordinate(x: starting.x + 1, y: starting.y);
    if (!box.isBottomSideWall &&
        comingFrom != Direction.bottom &&
        _getOneSolutionRecursive(board, nextStarting, partielSolition, Direction.top)) {
      partielSolition.add(nextStarting);
      return true;
    }
    return false;
  }
}
