import 'package:flutter/material.dart';
import 'package:game_2048/game_logic/board.dart';
import 'package:game_2048/game_logic/game.dart';
import 'package:game_2048/game_logic/stats.dart';
import 'package:game_2048/utils/color_palette.dart';
import 'package:provider/provider.dart';

class GameGrid extends StatefulWidget {
  const GameGrid({super.key});

  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  late final Board _board;
  late final Stats _stats;
  late final Game _game;

  var _startDx = 0.0;
  var _endDx = 0.0;
  var _movedHorizontally = false;

  var _startDy = 0.0;
  var _endDy = 0.0;
  var _movedVertically = false;

  void _updateStatsAndSpawnTile(MoveResult moveResult) {
    if (moveResult.shifted || moveResult.combinedValue > 0) {
      _stats.incMoves();
      _stats.startStopwatch();
      _stats.incScoreAndBest(moveResult.combinedValue);
      _board.spawnNewTile();
    }
  }

  void _onHorizontalDragStartHandler(DragStartDetails dragDetails) {
    _movedHorizontally = false;
    _startDx = dragDetails.localPosition.direction;
  }

  void _onHorizontalDragUpdateHandler(DragUpdateDetails dragDetails) {
    if (_movedHorizontally) {
      return;
    }

    _endDx = dragDetails.localPosition.direction;

    final moveResult =
        _endDx > _startDx ? _board.moveTilesLeft() : _board.moveTilesRight();
    _updateStatsAndSpawnTile(moveResult);
    _game.checkStatus(_board, _stats);

    _movedHorizontally = true;
  }

  void _onVerticalDragStartHandler(DragStartDetails dragDetails) {
    _movedVertically = false;
    _startDy = dragDetails.localPosition.direction;
  }

  void _onVerticalDragUpdateHandler(DragUpdateDetails dragDetails) {
    if (_movedVertically) {
      return;
    }

    _endDy = dragDetails.localPosition.direction;

    final moveResult =
        _endDy > _startDy ? _board.moveTilesDown() : _board.moveTilesUp();
    _updateStatsAndSpawnTile(moveResult);
    _game.checkStatus(_board, _stats);

    _movedVertically = true;
  }

  @override
  void initState() {
    super.initState();
    _board = Provider.of<Board>(context, listen: false);
    _stats = Provider.of<Stats>(context, listen: false);
    _game = Provider.of<Game>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStartHandler,
      onHorizontalDragUpdate: _onHorizontalDragUpdateHandler,
      onVerticalDragStart: _onVerticalDragStartHandler,
      onVerticalDragUpdate: _onVerticalDragUpdateHandler,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: kGridColor,
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: Consumer<Board>(
          builder: (context, board, child) => GridView.builder(
            padding: const EdgeInsets.all(12.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: board.gridSize * board.gridSize,
            itemBuilder: (context, index) => board.board1D[index] != 0
                ? _ActiveTile(value: board.board1D[index])
                : const _InactiveTile(),
          ),
        ),
      ),
    );
  }
}

class _ActiveTile extends StatelessWidget {
  const _ActiveTile({
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: kTileColors[value]?[0],
        borderRadius: const BorderRadius.all(
          Radius.circular(3.0),
        ),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: TextStyle(
            color: kTileColors[value]?[1],
            fontSize: 28.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _InactiveTile extends StatelessWidget {
  const _InactiveTile();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: kInactiveTileColor,
        borderRadius: BorderRadius.all(
          Radius.circular(3.0),
        ),
      ),
    );
  }
}
