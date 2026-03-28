import 'dart:math';
import '../utils/game_constants.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FallingLetter {
  final String id;
  final String letter;
  final double xPosition; // 0.0 to 1.0 (fraction of screen width)
  final PowerType? powerType;
  bool isCaught;
  bool isMissed;
  double yProgress; // 0.0 (top) to 1.0 (bottom)

  FallingLetter({
    required this.id,
    required this.letter,
    required this.xPosition,
    this.powerType,
    this.isCaught = false,
    this.isMissed = false,
    this.yProgress = 0.0,
  });

  bool get isPowerUp => powerType != null;

  Color get letterColor {
    if (powerType == PowerType.slow) return AppColors.slowPowerUp;
    if (powerType == PowerType.blast) return AppColors.blastPowerUp;
    if (powerType == PowerType.magnet) return AppColors.magnetPowerUp;
    if (powerType == PowerType.life) return AppColors.lifePowerUp;
    return AppColors.primary;
  }

  static FallingLetter generate(Random random, List<FallingLetter> existing) {
    final usedX = existing.map((e) => e.xPosition).toList();
    double x;
    int tries = 0;
    do {
      x = 0.05 + random.nextDouble() * 0.85;
      tries++;
    } while (usedX.any((ex) => (ex - x).abs() < 0.12) && tries < 20);

    final isPowerUp = random.nextDouble() < GameConstants.powerUpChance;
    PowerType? pt;
    if (isPowerUp) {
      pt = PowerType.values[random.nextInt(PowerType.values.length)];
    }

    final letter = GameConstants.letters[random.nextInt(GameConstants.letters.length)];

    return FallingLetter(
      id: '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(9999)}',
      letter: letter,
      xPosition: x,
      powerType: pt,
    );
  }
}
