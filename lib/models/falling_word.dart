import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/word_list.dart';
import '../utils/app_theme.dart';

class FallingWord {
  final String id;
  final String word;
  final double xPosition; // 0.0 to 1.0
  final WordDifficulty difficulty;
  bool isCaught;
  bool isMissed;
  double yProgress; // 0.0 (top) → 1.0 (bottom)

  FallingWord({
    required this.id,
    required this.word,
    required this.xPosition,
    required this.difficulty,
    this.isCaught = false,
    this.isMissed = false,
    this.yProgress = 0.0,
  });

  Color get cardColor {
    switch (difficulty) {
      case WordDifficulty.easy:
        return AppColors.secondary;
      case WordDifficulty.medium:
        return AppColors.primary;
      case WordDifficulty.hard:
        return AppColors.blastPowerUp;
    }
  }

  int get points {
    switch (difficulty) {
      case WordDifficulty.easy:
        return word.length * 8;
      case WordDifficulty.medium:
        return word.length * 12;
      case WordDifficulty.hard:
        return word.length * 18;
    }
  }

  static FallingWord generate(
      Random rng, List<FallingWord> existing, int totalSpawned) {
    final usedX = existing.map((e) => e.xPosition).toList();
    double x;
    int tries = 0;
    do {
      x = 0.05 + rng.nextDouble() * 0.7;
      tries++;
    } while (usedX.any((ex) => (ex - x).abs() < 0.18) && tries < 20);

    // Difficulty ramps up over time
    WordDifficulty diff;
    if (totalSpawned < 5) {
      diff = WordDifficulty.easy;
    } else if (totalSpawned < 15) {
      diff = rng.nextDouble() < 0.6 ? WordDifficulty.easy : WordDifficulty.medium;
    } else if (totalSpawned < 30) {
      final r = rng.nextDouble();
      diff = r < 0.3
          ? WordDifficulty.easy
          : r < 0.7
              ? WordDifficulty.medium
              : WordDifficulty.hard;
    } else {
      diff = rng.nextDouble() < 0.4
          ? WordDifficulty.medium
          : WordDifficulty.hard;
    }

    return FallingWord(
      id: '${DateTime.now().millisecondsSinceEpoch}_${rng.nextInt(9999)}',
      word: WordList.random(rng, diff),
      xPosition: x,
      difficulty: diff,
    );
  }
}
