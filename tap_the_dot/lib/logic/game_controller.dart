import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class GameState {
  final int score;
  final int highScore;
  final int round;
  final bool isOver;
  final Offset? dotPosition;
  final Color dotColor;
  final bool dotVisible;
  final bool showMiss;
  final int maxRounds;
  final int? lastReactionTimeMs;
  final double dotRadius;
  final bool soundEnabled;

  const GameState({
    required this.score,
    required this.highScore,
    required this.round,
    required this.isOver,
    required this.dotPosition,
    required this.dotColor,
    required this.dotVisible,
    required this.showMiss,
    required this.maxRounds,
    required this.lastReactionTimeMs,
    required this.dotRadius,
    required this.soundEnabled,
  });

  GameState copyWith({
    int? score,
    int? highScore,
    int? round,
    bool? isOver,
    Offset? dotPosition,
    Color? dotColor,
    bool? dotVisible,
    bool? showMiss,
    int? maxRounds,
    int? lastReactionTimeMs,
    double? dotRadius,
    bool? soundEnabled,
  }) {
    return GameState(
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      round: round ?? this.round,
      isOver: isOver ?? this.isOver,
      dotPosition: dotPosition ?? this.dotPosition,
      dotColor: dotColor ?? this.dotColor,
      dotVisible: dotVisible ?? this.dotVisible,
      showMiss: showMiss ?? this.showMiss,
      maxRounds: maxRounds ?? this.maxRounds,
      lastReactionTimeMs: lastReactionTimeMs ?? this.lastReactionTimeMs,
      dotRadius: dotRadius ?? this.dotRadius,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  factory GameState.initial(int highScore) {
    return GameState(
      score: 0,
      highScore: highScore,
      round: 0,
      isOver: false,
      dotPosition: null,
      dotColor: Colors.blue,
      dotVisible: false,
      showMiss: false,
      maxRounds: 20,
      lastReactionTimeMs: null,
      dotRadius: 36.0,
      soundEnabled: true,
    );
  }
}

class GameController extends ChangeNotifier {
  late GameState _state;
  Timer? _dotTimer;
  DateTime? _dotShownTime;
  final SharedPreferences prefs;
  static const highScoreKey = 'high_score';
  static const soundEnabledKey = 'sound_enabled';
  final Random _random = Random();

  GameController(this.prefs) : _state = GameState.initial(prefs.getInt(highScoreKey) ?? 0) {
    // Initialize sound enabled state from preferences
    final soundEnabled = prefs.getBool(soundEnabledKey);
    if (soundEnabled != null && soundEnabled != _state.soundEnabled) {
      _state = _state.copyWith(soundEnabled: soundEnabled);
    }
  }

  GameState get state => _state;

  void startGame() {
    final hs = prefs.getInt(highScoreKey) ?? 0;
    _state = GameState.initial(hs);
    notifyListeners();
    _nextRound();
  }

  void _showDot() {
    final pos = Offset(
      _random.nextDouble() * 0.8 + 0.1, // avoid edges
      _random.nextDouble() * 0.6 + 0.2,
    );
    final color = Colors.primaries[_random.nextInt(Colors.primaries.length)].withOpacity(0.9);
    _state = _state.copyWith(dotPosition: pos, dotColor: color, dotVisible: true);
    _dotShownTime = DateTime.now();
    notifyListeners();
    _dotTimer = Timer(const Duration(milliseconds: 1500), _missedDot);
  }

  void _nextRound() {
    if (_state.round >= _state.maxRounds) {
      _state = _state.copyWith(isOver: true, dotVisible: false);
      notifyListeners();
      return;
    }
    _state = _state.copyWith(round: _state.round + 1, dotVisible: false, showMiss: false);
    notifyListeners();
    // Delay a moment before showing next dot
    Timer(const Duration(milliseconds: 380), _showDot);
  }

  void onDotTapped() {
    _dotTimer?.cancel();
    final now = DateTime.now();
    final rt = _dotShownTime != null ? now.difference(_dotShownTime!).inMilliseconds : null;
    final newScore = _state.score + 1;
    final isNewHigh = newScore > _state.highScore;
    if (isNewHigh) {
      prefs.setInt(highScoreKey, newScore);
    }

    // Play success sound if enabled
    if (_state.soundEnabled) {
      // Use different sounds based on score (alternate between the select sounds)
      final soundIndex = newScore % 2;
      final soundFile = soundIndex == 0 ? 'assets/select-001-337218.mp3' : 'assets/video-games-select-337214.mp3';
      // Note: In a real app, you would initialize an audio player in the constructor
      // and use it to play sounds like this:
      // audioPlayer.play(AssetSource(soundFile));
    }

    _state = _state.copyWith(
      score: newScore,
      highScore: isNewHigh ? newScore : _state.highScore,
      lastReactionTimeMs: rt,
      dotVisible: false,
      showMiss: false,
    );
    notifyListeners();
    Timer(const Duration(milliseconds: 300), _nextRound);
  }

  void _missedDot() {
    // Play miss sound if enabled
    if (_state.soundEnabled) {
      // Note: In a real app, you would use the audio player to play the sound:
      // audioPlayer.play(AssetSource('assets/click-234708.mp3'));
    }

    _state = _state.copyWith(dotVisible: false, showMiss: true, lastReactionTimeMs: null);
    notifyListeners();
    Timer(const Duration(milliseconds: 700), _nextRound);
  }

  // Toggle sound enabled state
  void toggleSound() {
    final newSoundEnabled = !_state.soundEnabled;
    prefs.setBool(soundEnabledKey, newSoundEnabled);
    _state = _state.copyWith(soundEnabled: newSoundEnabled);
    notifyListeners();
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    super.dispose();
  }
}