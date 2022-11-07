import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_games/model/board.dart';
import 'package:flutter_games/model/coordinate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Providers/boardNotifier.dart';

class DisplayBoard extends ConsumerWidget {
  final Board board;
  const DisplayBoard({Key? key, required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenMinSize = min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height);
    var maxBoxSize = (screenMinSize - 100) / max(board.nbRow, board.nbColumn);
    List<Coordinate> solution = ref.watch(labyrinthSolutionProvider);

    return SizedBox(
      width: screenMinSize,
      height: screenMinSize,
      child: Table(
          children: List.generate(
              board.nbRow,
              (xAxis) => TableRow(
                      children: List.generate(board.nbColumn, (yAxis) {
                    return Container(
                      width: maxBoxSize,
                      height: maxBoxSize,
                      decoration: BoxDecoration(
                          color: solution.contains(Coordinate(x: xAxis, y: yAxis)) ? Colors.green : Colors.white,
                          border: Border(
                            top: board.labyrinth[xAxis][yAxis].isTopSideWall
                                ? boxBorderSide(xAxis == 0)
                                : BorderSide.none,
                            left: board.labyrinth[xAxis][yAxis].isLeftSideWall
                                ? boxBorderSide(yAxis == 0)
                                : BorderSide.none,
                            right: board.labyrinth[xAxis][yAxis].isRightSideWall
                                ? boxBorderSide(yAxis == board.nbColumn - 1)
                                : BorderSide.none,
                            bottom: board.labyrinth[xAxis][yAxis].isBottomSideWall
                                ? boxBorderSide(xAxis == board.nbRow - 1)
                                : BorderSide.none,
                          )),
                    );
                  })))),
    );
  }

  BorderSide boxBorderSide(bool isEdgeBox) {
    return BorderSide(color: Colors.black, width: isEdgeBox ? 6.0 : 3.0);
  }
}
