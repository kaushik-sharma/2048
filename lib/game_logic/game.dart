import 'package:flutter/material.dart';
import 'package:game_2048/game_logic/board.dart';
import 'package:game_2048/game_logic/stats.dart';

enum GameStatus {
  playing,
  won,
  over,
}

class Game with ChangeNotifier {
  var _gameStatus = GameStatus.playing;

  GameStatus get gameStatus => _gameStatus;

  void startNewGame(Board board, Stats stats) {
    board.resetBoard();
    stats.resetStats();
    _gameStatus = GameStatus.playing;
    notifyListeners();
  }

  bool _checkWon(Board board) {
    return board.board1D.contains(2048);
  }

  bool _checkOver(Board board) {
    final tempBoard = Board.from(board.tiles);
    var isOver = true;

    var leftResult = tempBoard.moveTilesLeft();
    var rightResult = tempBoard.moveTilesRight();
    var upResult = tempBoard.moveTilesUp();
    var downResult = tempBoard.moveTilesDown();

    if (leftResult.shifted ||
        leftResult.combinedValue > 0 ||
        rightResult.shifted ||
        rightResult.combinedValue > 0 ||
        upResult.shifted ||
        upResult.combinedValue > 0 ||
        downResult.shifted ||
        downResult.combinedValue > 0) {
      isOver = false;
    }

    return isOver;
  }

  void checkStatus(Board board, Stats stats) {
    final won = _checkWon(board);
    if (won) {
      _gameStatus = GameStatus.won;
      stats.stopStopwatch();
      notifyListeners();
      return;
    }

    final isOver = _checkOver(board);
    if (isOver) {
      _gameStatus = GameStatus.over;
      stats.stopStopwatch();
      notifyListeners();
      return;
    }
  }
}
