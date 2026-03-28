import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/falling_word.dart';
import '../utils/app_theme.dart';

class FallingWordWidget extends StatefulWidget {
  final FallingWord word;
  final double screenHeight;
  final double screenWidth;
  final double fallDuration;
  final void Function(String id) onFell;
  final String typedSoFar; // letters typed that match this word
  final bool isActive;     // currently being typed

  const FallingWordWidget({
    super.key,
    required this.word,
    required this.screenHeight,
    required this.screenWidth,
    required this.fallDuration,
    required this.onFell,
    required this.typedSoFar,
    required this.isActive,
  });

  @override
  State<FallingWordWidget> createState() => _FallingWordWidgetState();
}

class _FallingWordWidgetState extends State<FallingWordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _yAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.fallDuration * 1000).toInt()),
    );
    _yAnim = Tween<double>(begin: -80, end: widget.screenHeight + 20)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && !widget.word.isCaught) {
        widget.onFell(widget.word.id);
      }
    });
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(FallingWordWidget old) {
    super.didUpdateWidget(old);
    final newMs = (widget.fallDuration * 1000).toInt();
    if (_ctrl.duration?.inMilliseconds != newMs) {
      final progress = _ctrl.value;
      _ctrl.duration = Duration(milliseconds: newMs);
      _ctrl.forward(from: progress);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _yAnim,
      builder: (_, __) {
        widget.word.yProgress = _ctrl.value;

        final left = widget.word.xPosition * widget.screenWidth;

        if (widget.word.isCaught) {
          return Positioned(
            left: left,
            top: _yAnim.value,
            child: _buildCard()
                .animate()
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.4, 1.4),
                    duration: 300.ms)
                .fadeOut(duration: 300.ms),
          );
        }

        if (widget.word.isMissed) {
          return Positioned(
            left: left,
            top: _yAnim.value,
            child: _buildCard(missed: true)
                .animate()
                .shake(hz: 5, offset: const Offset(5, 0), duration: 400.ms)
                .fadeOut(duration: 400.ms),
          );
        }

        return Positioned(
          left: left,
          top: _yAnim.value,
          child: _buildCard(),
        );
      },
    );
  }

  Widget _buildCard({bool missed = false}) {
    final w = widget.word;
    final typed = widget.typedSoFar;
    final isActive = widget.isActive;
    final color = missed ? AppColors.error : w.cardColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: missed
            ? AppColors.error.withOpacity(0.12)
            : isActive
                ? color.withOpacity(0.18)
                : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: missed
              ? AppColors.error
              : isActive
                  ? color
                  : color.withOpacity(0.35),
          width: isActive ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isActive ? 0.3 : 0.12),
            blurRadius: isActive ? 14 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(w.word.length, (i) {
          final letter = w.word[i];
          final isTyped = isActive && i < typed.length;
          final isCurrent = isActive && i == typed.length;

          return Text(
            letter,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: missed
                  ? AppColors.error
                  : isTyped
                      ? color
                      : isCurrent
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
              // Underline the current letter being targeted
              decoration: isCurrent
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: color,
              decorationThickness: 2.5,
            ),
          );
        }),
      ),
    );
  }
}
