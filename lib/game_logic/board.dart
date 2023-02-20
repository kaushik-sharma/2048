import 'dart:math';

import 'package:flutter/material.dart';

class MoveResult {
  final bool shifted;
  final int combinedValue;

  const MoveResult(
    this.shifted,
    this.combinedValue,
  );
}

class Board with ChangeNotifier {
  final _gridSize = 4;
  final _tiles = <List<int>>[];

  Board() {
    _initBoard();
  }

  Board.from(List<List<int>> tiles) {
    for (var i = 0; i < _gridSize; i++) {
      _tiles.add([for (var j = 0; j < _gridSize; j++) 0]);
    }
    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        _tiles[i][j] = tiles[i][j];
      }
    }
  }

  int get gridSize => _gridSize;

  List<List<int>> get tiles {
    final tiles = <List<int>>[];
    for (var i = 0; i < _gridSize; i++) {
      tiles.add([for (var j = 0; j < _gridSize; j++) 0]);
    }
    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        tiles[i][j] = _tiles[i][j];
      }
    }
    return tiles;
  }

  List<int> get board1D {
    final tiles = <int>[];
    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        tiles.add(_tiles[i][j]);
      }
    }
    return tiles;
  }

  void _initBoard() {
    _tiles.clear();

    for (var i = 0; i < _gridSize; i++) {
      _tiles.add([for (var j = 0; j < _gridSize; j++) 0]);
    }

    final coOrds = <List<int>>[];
    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        coOrds.add([i, j]);
      }
    }
    for (var i = 0; i < 2; i++) {
      final index = Random().nextInt(coOrds.length);
      final coOrd = coOrds[index];
      coOrds.removeAt(index);
      _tiles[coOrd[0]][coOrd[1]] = Random().nextDouble() < 0.5 ? 2 : 4;
    }
  }

  bool _shiftTilesLeft() {
    var shifted = false;

    for (var i = 0; i < _gridSize; i++) {
      final newRow = List<int>.filled(_gridSize, 0);
      var index = 0;

      for (var j = 0; j < _gridSize; j++) {
        if (_tiles[i][j] != 0) {
          newRow[index++] = _tiles[i][j];
        }
      }

      for (var j = 0; j < _gridSize; j++) {
        if (_tiles[i][j] != newRow[j]) {
          shifted = true;
        }
        _tiles[i][j] = newRow[j];
      }
    }

    return shifted;
  }

  int _combineTilesLeft() {
    var combinedValue = 0;

    for (var i = 0; i < _gridSize; i++) {
      final newRow = List<int>.filled(_gridSize, 0);
      var index = 0;

      for (var j = 0; j < _gridSize; j++) {
        final currEl = _tiles[i][j];

        if (j + 1 >= _gridSize) {
          newRow[index++] = currEl;
          break;
        }

        final nextEl = _tiles[i][j + 1];

        if (currEl != 0 && nextEl != 0 && currEl == nextEl) {
          final newValue = currEl + nextEl;
          combinedValue += newValue;
          newRow[index++] = newValue;
          j++;
        } else {
          newRow[index++] = currEl;
        }
      }

      for (var j = 0; j < _gridSize; j++) {
        _tiles[i][j] = newRow[j];
      }
    }

    return combinedValue;
  }

  void _rotateBoardClockwise() {
    final newBoard = <List<int>>[];
    for (var i = 0; i < _gridSize; i++) {
      newBoard.add([for (var j = 0; j < _gridSize; j++) 0]);
    }

    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        newBoard[j][_gridSize - 1 - i] = _tiles[i][j];
      }
    }

    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        _tiles[i][j] = newBoard[i][j];
      }
    }
  }

  void spawnNewTile() {
    final coOrds = <List<int>>[];
    for (var i = 0; i < _gridSize; i++) {
      for (var j = 0; j < _gridSize; j++) {
        if (_tiles[i][j] == 0) {
          coOrds.add([i, j]);
        }
      }
    }

    final index = Random().nextInt(coOrds.length);
    final coOrd = coOrds[index];
    _tiles[coOrd[0]][coOrd[1]] = Random().nextDouble() < 0.5 ? 2 : 4;

    notifyListeners();
  }

  MoveResult moveTilesLeft() {
    final shifted = _shiftTilesLeft();
    final combinedValue = _combineTilesLeft();
    notifyListeners();
    return MoveResult(shifted, combinedValue);
  }

  MoveResult moveTilesRight() {
    _rotateBoardClockwise();
    _rotateBoardClockwise();
    final shifted = _shiftTilesLeft();
    final combinedValue = _combineTilesLeft();
    _rotateBoardClockwise();
    _rotateBoardClockwise();
    notifyListeners();
    return MoveResult(shifted, combinedValue);
  }

  MoveResult moveTilesUp() {
    _rotateBoardClockwise();
    _rotateBoardClockwise();
    _rotateBoardClockwise();
    final shifted = _shiftTilesLeft();
    final combinedValue = _combineTilesLeft();
    _rotateBoardClockwise();
    notifyListeners();
    return MoveResult(shifted, combinedValue);
  }

  MoveResult moveTilesDown() {
    _rotateBoardClockwise();
    final shifted = _shiftTilesLeft();
    final combinedValue = _combineTilesLeft();
    _rotateBoardClockwise();
    _rotateBoardClockwise();
    _rotateBoardClockwise();
    notifyListeners();
    return MoveResult(shifted, combinedValue);
  }

  void resetBoard() {
    _initBoard();
    notifyListeners();
  }
}
