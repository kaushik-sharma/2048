import 'package:flutter/material.dart';
import 'package:game_2048/game_logic/game.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.onTap,
    required this.gameStatus,
  });

  final VoidCallback onTap;
  final GameStatus gameStatus;

  @override
  Widget build(BuildContext context) {
    final message = gameStatus == GameStatus.won ? 'You won!' : 'You lost!';

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
        ),
        child: Center(
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '$message\n',
                  style: const TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: 'Tap to start a new game.',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
