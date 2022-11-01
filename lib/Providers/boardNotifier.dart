import 'dart:io';

import 'package:flutter_games/model/coordinate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LabyrinthNotifier extends StateNotifier<List<Coordinate>> {
  LabyrinthNotifier(): super([]);

  void addStep(Coordinate coordinate) {
    state = [...state, coordinate];
  }

  void removeStep(Coordinate coordinateToRemove) {
    state = [
      for (final coordinate in state)
        if (coordinate != coordinateToRemove) coordinate,
    ];
  }

  void addListStep(List<Coordinate> coordinates) {
    state = [...state, for(final coordinate in coordinates) coordinate];
  }

  Future <void> addListStepWithSleep(List<Coordinate> coordinates) async{
    for(final coordinate in coordinates) {
      state = [...state, coordinate];
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

}

final labyrinthSolutionProvider = StateNotifierProvider<LabyrinthNotifier, List<Coordinate>>((ref) {
  return LabyrinthNotifier();
});