import 'package:flutter/material.dart';
import 'package:flutter_games/model/coordinate.dart';
import 'package:flutter_games/utils/generator.dart';
import 'package:flutter_games/utils/solution_utils.dart';

import 'model/board.dart';
import 'widget/display_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Board board;
  List<Coordinate> solution = [];
  @override
  void initState() {
    board = perfectMazeGenerator(5, 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ElevatedButton(
            child: const Text("solution"),
            onPressed: () {
              setState(() {
                solution = SolutionUtils().getOneSolution(board, board.entryCoordinate);
                print(solution);
              });
            }),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 18),
        child: Center(child: DisplayBoard(board: board, solution: solution)),
      ),
    );
  }
}
