import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:async';
import '../models/falling_word.dart';
import '../utils/word_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordGameState extends ChangeNotifier {
  int score = 0;
  int lives = 3;
  int combo = 0;
  int maxCombo = 0;
  int totalCaught = 0;
  int totalMissed = 0;
  int bestScore = 0;
  int bestComboAllTime = 0;
  int totalWordsAllTime = 0;
  int totalSpawned = 0;

  bool isPlaying = false;
  bool isPaused = false;
  bool isGameOver = false;

  double fallDuration = 6.0; // seconds — words need more time
  bool isSlowActive = false;

  List<FallingWord> words = [];
  String currentInput = ''; // what the player has typed so far
  String? activeWordId;      // which word is being targeted
  String? lastCaughtId;
  String? lastMissedId;
  int lastWordPoints = 0;
  bool showPointsBurst = false;

  final Random _random = Random();
  Timer? _spawnTimer;
  Timer? _slowTimer;

  // ── Public API ──────────────────────────────────────────

  void startGame() {
    score = 0;
    lives = 3;
    combo = 0;
    maxCombo = 0;
    totalCaught = 0;
    totalMissed = 0;
    totalSpawned = 0;
    words.clear();
    currentInput = '';
    activeWordId = null;
    fallDuration = 6.0;
    isPlaying = true;
    isPaused = false;
    isGameOver = false;
    isSlowActive = false;
    _startSpawning();
    notifyListeners();
  }

  void onKeyTyped(String key) {
    if (!isPlaying || isPaused || isGameOver) return;
    final upper = key.toUpperCase();
    if (!RegExp(r'[A-Z]').hasMatch(upper)) return;

    currentInput += upper;
    _tryMatchWord();
    notifyListeners();
  }

  void onBackspace() {
    if (currentInput.isNotEmpty) {
      currentInput = currentInput.substring(0, currentInput.length - 1);
      // If no active word matches the trimmed input, clear active
      if (activeWordId != null) {
        final w = words.firstWhere((w) => w.id == activeWordId,
            orElse: () => _nullWord);
        if (w.id == '__null__' || !w.word.startsWith(currentInput)) {
          activeWordId = null;
          currentInput = '';
        }
      }
      notifyListeners();
    }
  }

  void onWordFell(String id) {
    final idx = words.indexWhere((w) => w.id == id);
    if (idx == -1) return;
    final word = words[idx];
    if (word.isCaught) return;

    word.isMissed = true;
    lastMissedId = id;
    lives--;
    combo = 0;
    totalMissed++;

    // Clear input if active word missed
    if (activeWordId == id) {
      activeWordId = null;
      currentInput = '';
    }

    notifyListeners();

    if (lives <= 0) {
      _endGame();
    } else {
      Future.delayed(const Duration(milliseconds: 700), () {
        words.removeWhere((w) => w.id == id);
        notifyListeners();
      });
    }
  }

  void pauseGame() {
    isPaused = true;
    notifyListeners();
  }

  void resumeGame() {
    isPaused = false;
    notifyListeners();
  }

  // ── Internal ────────────────────────────────────────────

  void _startSpawning() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
      if (!isPaused && isPlaying) {
        if (words.where((w) => !w.isCaught && !w.isMissed).length < 4) {
          words.add(FallingWord.generate(_random, words, totalSpawned));
          totalSpawned++;
          // Speed up gradually
          fallDuration = (6.0 - (totalSpawned * 0.08)).clamp(2.8, 6.0);
          notifyListeners();
        }
      }
    });
  }

  void _tryMatchWord() {
    if (currentInput.isEmpty) {
      activeWordId = null;
      return;
    }

    final active = words.where((w) => !w.isCaught && !w.isMissed).toList();

    // If already targeting a word, check it first
    if (activeWordId != null) {
      final target = active.firstWhere((w) => w.id == activeWordId,
          orElse: () => _nullWord);
      if (target.id != '__null__') {
        if (target.word.startsWith(currentInput)) {
          if (currentInput == target.word) {
            _catchWord(target.id);
          }
          return;
        } else {
          // Typed wrong letter — clear
          activeWordId = null;
          currentInput = currentInput.substring(0, currentInput.length - 1);
          notifyListeners();
          return;
        }
      }
    }

    // Find a word that starts with currentInput
    // Prefer lowest on screen (highest yProgress = most urgent)
    final matches = active
        .where((w) => w.word.startsWith(currentInput))
        .toList()
      ..sort((a, b) => b.yProgress.compareTo(a.yProgress));

    if (matches.isEmpty) {
      // No match — reset input
      currentInput = '';
      activeWordId = null;
      return;
    }

    activeWordId = matches.first.id;

    if (currentInput == matches.first.word) {
      _catchWord(matches.first.id);
    }
  }

  void _catchWord(String id) {
    final idx = words.indexWhere((w) => w.id == id);
    if (idx == -1) return;
    final fw = words[idx];
    if (fw.isCaught) return;

    fw.isCaught = true;
    lastCaughtId = id;
    totalCaught++;
    combo++;
    if (combo > maxCombo) maxCombo = combo;

    final multiplier = _comboMultiplier;
    lastWordPoints = (fw.points * multiplier).toInt();
    score += lastWordPoints;
    showPointsBurst = true;

    currentInput = '';
    activeWordId = null;

    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      showPointsBurst = false;
      words.removeWhere((w) => w.id == id);
      notifyListeners();
    });
  }

  double get _comboMultiplier {
    if (combo >= 8) return 3.0;
    if (combo >= 4) return 2.0;
    if (combo >= 2) return 1.5;
    return 1.0;
  }

  double get currentFallDuration =>
      isSlowActive ? fallDuration * 2.0 : fallDuration;

  void _endGame() {
    isPlaying = false;
    isGameOver = true;
    _spawnTimer?.cancel();
    _slowTimer?.cancel();
    _saveScore();
    notifyListeners();
  }

  Future<void> loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    bestScore = prefs.getInt('word_best_score') ?? 0;
    totalWordsAllTime = prefs.getInt('word_total') ?? 0;
    bestComboAllTime = prefs.getInt('word_best_combo') ?? 0;
    notifyListeners();
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > bestScore) {
      bestScore = score;
      await prefs.setInt('word_best_score', bestScore);
    }
    totalWordsAllTime += totalCaught;
    await prefs.setInt('word_total', totalWordsAllTime);
    if (maxCombo > bestComboAllTime) {
      bestComboAllTime = maxCombo;
      await prefs.setInt('word_best_combo', bestComboAllTime);
    }
  }

  int get accuracy => totalCaught + totalMissed == 0
      ? 100
      : ((totalCaught / (totalCaught + totalMissed)) * 100).round();

  // Sentinel null-object to avoid nullable headaches
  static final _nullWord = FallingWord(
    id: '__null__',
    word: '',
    xPosition: 0,
    difficulty: WordDifficulty.easy,
  );

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _slowTimer?.cancel();
    super.dispose();
  }
}
