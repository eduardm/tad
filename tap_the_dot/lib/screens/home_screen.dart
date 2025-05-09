import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/game_screen.dart';
import '../providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap the Dot'),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, _) {
              try {
                final gameController = ref.watch(gameControllerProvider);
                return IconButton(
                  icon: Icon(gameController.state.soundEnabled ? Icons.volume_up : Icons.volume_off),
                  tooltip: 'Toggle Sound',
                  onPressed: () {
                    ref.read(gameControllerProvider.notifier).toggleSound();
                  },
                );
              } catch (e) {
                // Return a default icon if there's an issue with the provider
                return const IconButton(
                  icon: Icon(Icons.volume_off),
                  tooltip: 'Sound (unavailable)',
                  onPressed: null,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tap the Dot!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const Text('Tap the colored dot as fast as you can before it disappears!', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 18)
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
                child: const Text('Start Game', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}