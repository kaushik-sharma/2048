import 'dart:async';

import 'package:flutter/material.dart';

class Stats with ChangeNotifier {
  var _moves = 0;
  final _stopwatch = Stopwatch();
  var _score = 0;
  var _best = 0;

  int get moves => _moves;

  int get elapsedSeconds => _stopwatch.elapsed.inSeconds;

  int get score => _score;

  int get best => _best;

  void incMoves() {
    _moves++;
    notifyListeners();
  }

  void startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      Timer.periodic(
        const Duration(milliseconds: 500),
        (timer) => notifyListeners(),
      );
    }
  }

  void incScoreAndBest(int value) {
    _score += value;
    if (_score > _best) {
      _best = _score;
    }
    notifyListeners();
  }

  void stopStopwatch() {
    _stopwatch.stop();
    notifyListeners();
  }

  void resetStats() {
    _moves = 0;
    _stopwatch.stop();
    _stopwatch.reset();
    _score = 0;
    notifyListeners();
  }
}
