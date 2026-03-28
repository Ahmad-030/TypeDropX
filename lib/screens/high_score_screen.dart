import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_state.dart';
import '../utils/app_theme.dart';

class HighScoreScreen extends StatefulWidget {
  final GameState gameState;
  const HighScoreScreen({super.key, required this.gameState});

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  int _displayScore = 0;
  int _displayLetters = 0;
  int _displayCombo = 0;

  @override
  void initState() {
    super.initState();
    _animateCounters();
  }

  void _animateCounters() async {
    final gs = widget.gameState;
    const steps = 25;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 28));
      if (!mounted) return;
      setState(() {
        _displayScore = (gs.bestScore * i / steps).toInt();
        _displayLetters = (gs.totalLettersAllTime * i / steps).toInt();
        _displayCombo = (gs.bestComboAllTime * i / steps).toInt();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'High Score',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Trophy
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 52)),
                  ),
                ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.7, 0.7)),
              ),
              const SizedBox(height: 32),
              // Stats cards
              _StatCard(
                label: 'BEST SCORE',
                value: '$_displayScore',
                icon: Icons.star_rounded,
                color: AppColors.primary,
                delay: 100,
              ),
              const SizedBox(height: 16),
              _StatCard(
                label: 'TOTAL LETTERS CAUGHT',
                value: '$_displayLetters',
                icon: Icons.keyboard_rounded,
                color: AppColors.secondary,
                delay: 200,
              ),
              const SizedBox(height: 16),
              _StatCard(
                label: 'BEST COMBO',
                value: 'x$_displayCombo',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.accent,
                delay: 300,
              ),
              const SizedBox(height: 16),
              _StatCard(
                label: 'ACCURACY',
                value: '${widget.gameState.accuracy}%',
                icon: Icons.gps_fixed_rounded,
                color: AppColors.magnetPowerUp,
                delay: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn(duration: 400.ms).slideX(begin: 0.3, end: 0);
  }
}
