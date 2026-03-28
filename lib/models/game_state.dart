import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:async';
import '../models/falling_letter.dart';
import '../utils/game_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier {
  int score = 0;
  int lives = GameConstants.initialLives;
  int combo = 0;
  int maxCombo = 0;
  int totalCaught = 0;
  int totalMissed = 0;
  int bestScore = 0;
  int totalLettersAllTime = 0;
  int bestComboAllTime = 0;

  bool isPlaying = false;
  bool isPaused = false;
  bool isGameOver = false;

  double fallDuration = GameConstants.initialFallSpeed;
  bool isSlowActive = false;
  bool isMagnetActive = false;
  PowerType? activePowerType;

  List<FallingLetter> letters = [];
  String? lastCaughtId;
  String? lastMissedId;
  String? lastPowerUpType;

  final Random _random = Random();
  Timer? _spawnTimer;
  Timer? _powerTimer;

  void startGame() {
    score = 0;
    lives = GameConstants.initialLives;
    combo = 0;
    maxCombo = 0;
    totalCaught = 0;
    totalMissed = 0;
    letters.clear();
    fallDuration = GameConstants.initialFallSpeed;
    isPlaying = true;
    isPaused = false;
    isGameOver = false;
    isSlowActive = false;
    isMagnetActive = false;
    activePowerType = null;
    _startSpawning();
    notifyListeners();
  }

  void _startSpawning() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(
      Duration(milliseconds: GameConstants.letterSpawnIntervalMs),
      (_) {
        if (!isPaused && isPlaying) {
          if (letters.where((l) => !l.isCaught && !l.isMissed).length <
              GameConstants.maxSimultaneousLetters) {
            letters.add(FallingLetter.generate(_random, letters));
            notifyListeners();
          }
        }
      },
    );
  }

  void onLetterFell(String id) {
    final idx = letters.indexWhere((l) => l.id == id);
    if (idx == -1) return;
    final letter = letters[idx];
    if (letter.isCaught) return;

    if (isMagnetActive) {
      _catchLetter(id, letter.letter, fromMagnet: true);
      return;
    }

    letter.isMissed = true;
    lastMissedId = id;
    lives--;
    combo = 0;
    totalMissed++;
    notifyListeners();

    if (lives <= 0) {
      _endGame();
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        letters.removeWhere((l) => l.id == id);
        notifyListeners();
      });
    }
  }

  void onKeyTyped(String key) {
    if (!isPlaying || isPaused || isGameOver) return;
    final upper = key.toUpperCase();

    // Find topmost matching visible letter
    final matches = letters
        .where((l) => l.letter == upper && !l.isCaught && !l.isMissed)
        .toList();
    if (matches.isEmpty) return;

    matches.sort((a, b) => b.yProgress.compareTo(a.yProgress));
    final target = matches.first;
    _catchLetter(target.id, target.letter);
  }

  void _catchLetter(String id, String letter, {bool fromMagnet = false}) {
    final idx = letters.indexWhere((l) => l.id == id);
    if (idx == -1) return;
    final fl = letters[idx];
    if (fl.isCaught) return;

    fl.isCaught = true;
    lastCaughtId = id;
    totalCaught++;
    combo++;
    if (combo > maxCombo) maxCombo = combo;

    final multiplier = _comboMultiplier;
    score += (GameConstants.scorePerLetter * multiplier).toInt();

    if (fl.isPowerUp) {
      _activatePowerUp(fl.powerType!);
    }

    // Increase speed every 5 catches
    if (totalCaught % 5 == 0 && !isSlowActive) {
      fallDuration = max(GameConstants.minFallSpeed, fallDuration - GameConstants.speedIncrement);
    }

    notifyListeners();
    Future.delayed(const Duration(milliseconds: 400), () {
      letters.removeWhere((l) => l.id == id);
      notifyListeners();
    });
  }

  double get _comboMultiplier {
    if (combo >= 10) return 3.0;
    if (combo >= 5) return 2.0;
    if (combo >= 3) return 1.5;
    return 1.0;
  }

  void _activatePowerUp(PowerType type) {
    activePowerType = type;
    lastPowerUpType = type.name;
    _powerTimer?.cancel();

    switch (type) {
      case PowerType.slow:
        isSlowActive = true;
        _powerTimer = Timer(Duration(seconds: GameConstants.powerUpDuration), () {
          isSlowActive = false;
          activePowerType = null;
          notifyListeners();
        });
        break;
      case PowerType.blast:
        for (final l in letters) {
          l.isCaught = true;
          score += GameConstants.scorePerLetter;
        }
        Future.delayed(const Duration(milliseconds: 300), () {
          letters.clear();
          activePowerType = null;
          notifyListeners();
        });
        break;
      case PowerType.magnet:
        isMagnetActive = true;
        _powerTimer = Timer(Duration(seconds: GameConstants.powerUpDuration), () {
          isMagnetActive = false;
          activePowerType = null;
          notifyListeners();
        });
        break;
      case PowerType.life:
        if (lives < 5) lives++;
        activePowerType = null;
        break;
    }
    notifyListeners();
  }

  void pauseGame() {
    isPaused = true;
    notifyListeners();
  }

  void resumeGame() {
    isPaused = false;
    notifyListeners();
  }

  void _endGame() {
    isPlaying = false;
    isGameOver = true;
    _spawnTimer?.cancel();
    _powerTimer?.cancel();
    _saveScore();
    notifyListeners();
  }

  Future<void> loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    bestScore = prefs.getInt('best_score') ?? 0;
    totalLettersAllTime = prefs.getInt('total_letters') ?? 0;
    bestComboAllTime = prefs.getInt('best_combo') ?? 0;
    notifyListeners();
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > bestScore) {
      bestScore = score;
      await prefs.setInt('best_score', bestScore);
    }
    totalLettersAllTime += totalCaught;
    await prefs.setInt('total_letters', totalLettersAllTime);
    if (maxCombo > bestComboAllTime) {
      bestComboAllTime = maxCombo;
      await prefs.setInt('best_combo', bestComboAllTime);
    }
  }

  int get accuracy => totalCaught + totalMissed == 0
      ? 100
      : ((totalCaught / (totalCaught + totalMissed)) * 100).round();

  double get currentFallDuration =>
      isSlowActive ? fallDuration * 2.0 : fallDuration;

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _powerTimer?.cancel();
    super.dispose();
  }
}
