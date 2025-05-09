import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logic/game_controller.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final gameControllerProvider = ChangeNotifierProvider<GameController>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return GameController(prefs);
}, dependencies: [sharedPreferencesProvider]);