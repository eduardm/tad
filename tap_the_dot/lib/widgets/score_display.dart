import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int highScore;
  final int? reactionTime;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.highScore,
    required this.reactionTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ScoreItem(label: 'Score', value: score.toString()),
        _ScoreItem(label: 'High', value: highScore.toString()),
        _ScoreItem(label: 'Last ms', value: reactionTime != null ? reactionTime.toString() : '--'),
      ],
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final String value;
  const _ScoreItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: Text(
            value,
            key: ValueKey(value),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}