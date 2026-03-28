import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/game_constants.dart';

class FloatingLettersBg extends StatefulWidget {
  const FloatingLettersBg({super.key});

  @override
  State<FloatingLettersBg> createState() => _FloatingLettersBgState();
}

class _LetterItem {
  double x, y, speed, opacity, size, angle;
  String letter;
  _LetterItem(
      {required this.x,
      required this.y,
      required this.speed,
      required this.opacity,
      required this.size,
      required this.angle,
      required this.letter});
}

class _FloatingLettersBgState extends State<FloatingLettersBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_LetterItem> _items = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateItems();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_tick);
  }

  void _generateItems() {
    for (int i = 0; i < 18; i++) {
      _items.add(_LetterItem(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.0008 + _random.nextDouble() * 0.0012,
        opacity: 0.04 + _random.nextDouble() * 0.08,
        size: 18.0 + _random.nextDouble() * 28,
        angle: _random.nextDouble() * pi * 2,
        letter: GameConstants.letters[_random.nextInt(26)],
      ));
    }
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      for (final item in _items) {
        item.y += item.speed;
        if (item.y > 1.1) {
          item.y = -0.1;
          item.x = _random.nextDouble();
          item.letter = GameConstants.letters[_random.nextInt(26)];
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: _items
            .map((item) => Positioned(
                  left: item.x * constraints.maxWidth,
                  top: item.y * constraints.maxHeight,
                  child: Transform.rotate(
                    angle: item.angle,
                    child: Text(
                      item.letter,
                      style: TextStyle(
                        fontSize: item.size,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary.withOpacity(item.opacity),
                      ),
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }
}
