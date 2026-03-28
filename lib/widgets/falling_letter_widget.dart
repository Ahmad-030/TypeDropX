import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/falling_letter.dart';
import '../utils/app_theme.dart';
import '../utils/game_constants.dart';

class FallingLetterWidget extends StatefulWidget {
  final FallingLetter letter;
  final double screenHeight;
  final double screenWidth;
  final double fallDuration;
  final void Function(String id) onFell;

  const FallingLetterWidget({
    super.key,
    required this.letter,
    required this.screenHeight,
    required this.screenWidth,
    required this.fallDuration,
    required this.onFell,
  });

  @override
  State<FallingLetterWidget> createState() => _FallingLetterWidgetState();
}

class _FallingLetterWidgetState extends State<FallingLetterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _yAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: (widget.fallDuration * 1000).toInt()),
    );
    _yAnim = Tween<double>(begin: -80, end: widget.screenHeight + 20)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!widget.letter.isCaught) {
          widget.onFell(widget.letter.id);
        }
      }
    });
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(FallingLetterWidget old) {
    super.didUpdateWidget(old);
    // Update speed when power-up changes
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
        // Track y progress for magnet logic
        widget.letter.yProgress = _ctrl.value;

        if (widget.letter.isCaught) {
          return Positioned(
            left: widget.letter.xPosition * widget.screenWidth - 28,
            top: _yAnim.value,
            child: _buildTile()
                .animate()
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.6, 1.6),
                    duration: 300.ms)
                .fadeOut(duration: 300.ms),
          );
        }
        if (widget.letter.isMissed) {
          return Positioned(
            left: widget.letter.xPosition * widget.screenWidth - 28,
            top: _yAnim.value,
            child: _buildTile(missed: true)
                .animate()
                .shake(hz: 6, offset: const Offset(4, 0), duration: 400.ms)
                .fadeOut(duration: 400.ms),
          );
        }
        return Positioned(
          left: widget.letter.xPosition * widget.screenWidth - 28,
          top: _yAnim.value,
          child: _buildTile(),
        );
      },
    );
  }

  Widget _buildTile({bool missed = false}) {
    final isPU = widget.letter.isPowerUp;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: missed ? AppColors.error.withOpacity(0.15) : (isPU ? widget.letter.letterColor.withOpacity(0.15) : AppColors.cardBg),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: missed
              ? AppColors.error
              : (isPU ? widget.letter.letterColor : AppColors.primary.withOpacity(0.2)),
          width: isPU ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (missed ? AppColors.error : widget.letter.letterColor)
                .withOpacity(isPU ? 0.25 : 0.1),
            blurRadius: isPU ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isPU)
            Text(
              GameConstants.powerUpEmoji[widget.letter.powerType]!,
              style: const TextStyle(fontSize: 10),
            ),
          Text(
            widget.letter.letter,
            style: TextStyle(
              fontSize: isPU ? 20 : 24,
              fontWeight: FontWeight.w900,
              color: missed
                  ? AppColors.error
                  : (isPU ? widget.letter.letterColor : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
