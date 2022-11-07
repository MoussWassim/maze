import 'dart:math';

import 'package:flutter_games/model/coordinate.dart';
import 'package:flutter_games/model/stack.dart';

import '../model/board.dart';
import '../model/box.dart';
import 'bord_utils.dart';

/// Generate a random coordinate for entrance/box in board
///
/// nbRow: number of row in the board
/// nbColumn: number of column in the board
Coordinate randomEntryCoordinate(int nbRow, int nbColumn) {
  var isHorizontalSideDoor = Random().nextBool();
  var x = isHorizontalSideDoor ? Random().nextInt(nbRow) : 0;
  var y = isHorizontalSideDoor ? 0 : Random().nextInt(nbColumn);
  return Coordinate(x: x, y: y);
}

/// Generate a random coordinate for exit box in board
///
/// nbRow: number of row in the board
/// nbColumn: number of column in the board
Coordinate randomExitCoordinate(int nbRow, int nbColumn, {Coordinate? entryCoordinate}) {
  var isHorizontalSideDoor = Random().nextBool();
  var x = isHorizontalSideDoor ? Random().nextInt(nbRow) : nbRow - 1;
  while (entryCoordinate != null && entryCoordinate.x == x) {
    x = isHorizontalSideDoor ? Random().nextInt(nbRow) : nbRow - 1;
  }
  var y = isHorizontalSideDoor ? nbColumn - 1 : Random().nextInt(nbColumn);
  while (entryCoordinate != null && entryCoordinate.y == y) {
    y = isHorizontalSideDoor ? nbColumn - 1 : Random().nextInt(nbColumn);
  }
  return Coordinate(x: x, y: y);
}

Board perfectMazeGenerator(int nbRow, int nbColumn) {
  Board board = generateFullBoard(nbRow, nbColumn);
  var hasBeenVisited = List.generate(nbRow, (index) => List.generate(nbColumn, (_) => false));
  generateBoardEntry(nbRow, nbColumn, board);
  Stack<Coordinate> stack = Stack<Coordinate>();
  stack.push(board.entryCoordinate);
  hasBeenVisited[board.entryCoordinate.x][board.entryCoordinate.y] = true;

  while (stack.isNotEmpty) {
    var currentCell = stack.pop();
    List<Coordinate> unvisitedNeighbors = _getInvisitedNeighbors(currentCell, hasBeenVisited, nbRow, nbColumn);
    if (unvisitedNeighbors.isNotEmpty) {
      stack.push(currentCell);
      Coordinate nextCell = _peekRandomNeighbor(unvisitedNeighbors);
      _deleteWallCell(board, currentCell, nextCell);
      hasBeenVisited[nextCell.x][nextCell.y] = true;
      stack.push(nextCell);
    }
  }
  generateBoardExit(board, nbRow, nbColumn, entryCoordinate: board.entryCoordinate);

  return board;
}

void generateBoardExit(Board board, int nbRow, int nbColumn, {Coordinate? entryCoordinate}) {
  board.exitCoordinate = randomExitCoordinate(nbRow, nbColumn, entryCoordinate: entryCoordinate);
  if (board.exitCoordinate.y == nbColumn-1) {
    board.labyrinth[board.exitCoordinate.x][board.exitCoordinate.y].isRightSideWall = false;
  } else {
    board.labyrinth[board.exitCoordinate.x][board.exitCoordinate.y].isBottomSideWall = false;
  }
}

void generateBoardEntry(int nbRow, int nbColumn, Board board) {
  board.entryCoordinate = randomEntryCoordinate(nbRow, nbColumn);
  if (board.entryCoordinate.y == 0) {
    board.labyrinth[board.entryCoordinate.x][board.entryCoordinate.y].isLeftSideWall = false;
  } else {
    board.labyrinth[board.entryCoordinate.x][board.entryCoordinate.y].isTopSideWall = false;
  }
}

void _deleteWallCell(Board board, Coordinate currentCell, Coordinate nextCell) {
  if (currentCell.x - nextCell.x > 0) {
    board.labyrinth[currentCell.x][currentCell.y].isTopSideWall = false;
    board.labyrinth[nextCell.x][nextCell.y].isBottomSideWall = false;
  } else if (currentCell.x - nextCell.x < 0) {
    board.labyrinth[currentCell.x][currentCell.y].isBottomSideWall = false;
    board.labyrinth[nextCell.x][nextCell.y].isTopSideWall = false;
  } else if (currentCell.y - nextCell.y > 0) {
    board.labyrinth[currentCell.x][currentCell.y].isLeftSideWall = false;
    board.labyrinth[nextCell.x][nextCell.y].isRightSideWall = false;
  } else {
    board.labyrinth[currentCell.x][currentCell.y].isRightSideWall = false;
    board.labyrinth[nextCell.x][nextCell.y].isLeftSideWall = false;
  }
}

Coordinate _peekRandomNeighbor(List<Coordinate> unvisitedNeighbors) {
  var randomPosition = Random().nextInt(unvisitedNeighbors.length);
  return unvisitedNeighbors[randomPosition];
}

List<Coordinate> _getInvisitedNeighbors(
    Coordinate currentCell, List<List<bool>> hasBeenVisited, int nbRow, int nbColumn) {
  var invisitedNeighbors = <Coordinate>[];
  if (currentCell.x + 1 < nbRow && !hasBeenVisited[currentCell.x + 1][currentCell.y]) {
    invisitedNeighbors.add(Coordinate(x: currentCell.x + 1, y: currentCell.y));
  }
  if (currentCell.x - 1 >= 0 && !hasBeenVisited[currentCell.x - 1][currentCell.y]) {
    invisitedNeighbors.add(Coordinate(x: currentCell.x - 1, y: currentCell.y));
  }
  if (currentCell.y + 1 < nbColumn && !hasBeenVisited[currentCell.x][currentCell.y + 1]) {
    invisitedNeighbors.add(Coordinate(x: currentCell.x, y: currentCell.y + 1));
  }
  if (currentCell.y - 1 >= 0 && !hasBeenVisited[currentCell.x][currentCell.y - 1]) {
    invisitedNeighbors.add(Coordinate(x: currentCell.x, y: currentCell.y - 1));
  }
  return invisitedNeighbors;
}

Board generateFullBoard(int nbRow, int nbColumn) {
  var labyrinth = List.generate(
      nbRow,
      (index) => List.generate(nbColumn,
          (_) => Box(isBottomSideWall: true, isLeftSideWall: true, isRightSideWall: true, isTopSideWall: true)));
  return Board(labyrinth: labyrinth, nbRow: nbRow, nbColumn: nbColumn, entryCoordinate: const Coordinate(x: 0, y: 0), exitCoordinate: const Coordinate(x: 0, y: 0));
}

Board generateBoardfromLength(int nbRow, int nbColumn) {
  var labyrinth = List.generate(nbRow, (index) => List.generate(nbColumn, (_) => Box()));

  for (int i = 0; i < nbRow; i++) {
    labyrinth[i][0].isLeftSideWall = true;
    labyrinth[i][nbColumn - 1].isRightSideWall = true;
  }

  for (int j = 0; j < nbColumn; j++) {
    labyrinth[0][j].isTopSideWall = true;
    labyrinth[nbRow - 1][j].isBottomSideWall = true;
  }

  var entryCoordinate = randomEntryCoordinate(nbRow, nbColumn);
  var isTopSideEntry = entryCoordinate.x == 0;
  if (isTopSideEntry) {
    labyrinth[entryCoordinate.x][entryCoordinate.y].isTopSideWall = false;
  } else {
    labyrinth[entryCoordinate.x][entryCoordinate.y].isLeftSideWall = false;
  }

  var exitCoordinate = randomExitCoordinate(nbRow, nbColumn);
  var isBottomExit = exitCoordinate.x == nbRow - 1;
  if (isBottomExit) {
    labyrinth[exitCoordinate.x][exitCoordinate.y].isBottomSideWall = false;
  } else {
    labyrinth[exitCoordinate.x][exitCoordinate.y].isRightSideWall = false;
  }
  var board = Board(labyrinth: labyrinth, nbRow: nbRow, nbColumn: nbColumn, entryCoordinate: entryCoordinate, exitCoordinate: exitCoordinate);
  populateBoard(board);

  return board;
}
