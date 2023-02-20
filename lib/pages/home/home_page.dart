import 'package:flutter/material.dart';
import 'package:game_2048/game_logic/board.dart';
import 'package:game_2048/game_logic/game.dart';
import 'package:game_2048/game_logic/stats.dart';
import 'package:game_2048/pages/home/components/button.dart';
import 'package:game_2048/pages/home/components/game_grid.dart';
import 'package:game_2048/pages/home/components/message.dart';
import 'package:game_2048/pages/home/components/score_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String getFormattedTime(int secondsElapsed) {
    final minutes = secondsElapsed ~/ 60;
    final seconds = secondsElapsed - minutes * 60;
    final secondsText = seconds < 10 ? '0$seconds' : '$seconds';
    return '$minutes:$secondsText';
  }

  Widget buildStatsText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.brown.shade200,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context, listen: false);
    final stats = Provider.of<Stats>(context, listen: false);
    final game = Provider.of<Game>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<Stats>(
                          builder: (context, stats, child) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ScoreCard(
                                title: 'Score',
                                value: stats.score,
                              ),
                              const SizedBox(width: 10.0),
                              ScoreCard(
                                title: 'Best',
                                value: stats.best,
                              ),
                            ],
                          ),
                        ),
                        Button(
                          onTap: () => game.startNewGame(board, stats),
                          text: 'New',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Join the numbers and get to the 2048 tile!',
                    style: TextStyle(
                      color: Colors.brown.shade400,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const GameGrid(),
                  const SizedBox(height: 20.0),
                  Consumer<Stats>(
                    builder: (context, stats, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildStatsText('${stats.moves} moves'),
                        buildStatsText(getFormattedTime(stats.elapsedSeconds)),
                      ],
                    ),
                  ),
                ],
              ),
              Consumer<Game>(
                builder: (context, game, child) => Visibility(
                  visible: game.gameStatus == GameStatus.won ||
                      game.gameStatus == GameStatus.over,
                  child: Message(
                    onTap: () => game.startNewGame(board, stats),
                    gameStatus: game.gameStatus,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
