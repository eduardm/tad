import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/dot_widget.dart';
import '../widgets/score_display.dart';
import '../widgets/miss_indicator.dart';
import '../screens/game_over_screen.dart';
import '../logic/game_controller.dart';
import '../providers.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});
  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Start/restart game logic on entering game screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Use ref.read to avoid rebuilding during build phase
        final controller = ref.read(gameControllerProvider);
        controller.startGame();
      } catch (e) {
        // Handle error silently
        debugPrint('Error starting game: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Use try-catch to handle any provider errors
    try {
      final gameController = ref.watch(gameControllerProvider);
      final gameState = gameController.state;
      
      return buildGameScreen(context, size, gameController, gameState);
    } catch (e) {
      // Return a basic loading screen if there's an issue with the provider
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading game...')
            ],
          ),
        ),
      );
    }
  }

  // Helper method to build the game screen once we have a valid controller
  Widget buildGameScreen(BuildContext context, Size size, GameController gameController, GameState gameState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap the Dot'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(gameState.soundEnabled ? Icons.volume_up : Icons.volume_off),
            tooltip: 'Toggle Sound',
            onPressed: () {
              gameController.toggleSound();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
            onPressed: () { gameController.startGame(); },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Score and status area
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: ScoreDisplay(score: gameState.score, highScore: gameState.highScore, reactionTime: gameState.lastReactionTimeMs),
          ),
          // Dot (if active)
          if (!gameState.isOver && gameState.dotVisible && gameState.dotPosition != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              left: gameState.dotPosition!.dx * (size.width - gameState.dotRadius * 2),
              top: gameState.dotPosition!.dy * (size.height - gameState.dotRadius * 2 - 100) + 60,
              child: DotWidget(
                color: gameState.dotColor,
                radius: gameState.dotRadius,
                onTap: () {
                  ref.read(gameControllerProvider.notifier).onDotTapped();
                },
              ),
            ),
          // Miss indicator (animated)
          if (gameState.showMiss)
            Center(child: MissIndicator()),
          // Game Over overlay
          if (gameState.isOver)
            GameOverScreen(
              score: gameState.score,
              highScore: gameState.highScore,
              onRestart: () => gameController.startGame(),
            ),
        ],
      ),
    );
  }
}