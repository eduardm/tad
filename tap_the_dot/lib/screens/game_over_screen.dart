import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRestart;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.highScore,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Material(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Game Over', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 16),
                  Text('Your Score: $score', style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 8),
                  Text('High Score: $highScore', style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: onRestart,
                    child: const Text('Restart', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () { Navigator.of(context).pop(); },
                    child: const Text('Exit to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}