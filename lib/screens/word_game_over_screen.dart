import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word_game_state.dart';
import '../utils/app_theme.dart';
import '../widgets/menu_button.dart';
import 'menu_screen.dart';
import 'word_game_screen.dart';

class WordGameOverScreen extends StatefulWidget {
  final WordGameState gameState;
  const WordGameOverScreen({super.key, required this.gameState});

  @override
  State<WordGameOverScreen> createState() => _WordGameOverScreenState();
}

class _WordGameOverScreenState extends State<WordGameOverScreen> {
  int _displayScore = 0;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.gameState.score >= widget.gameState.bestScore &&
        widget.gameState.score > 0;
    _animateScore();
  }

  void _animateScore() async {
    final target = widget.gameState.score;
    const steps = 30;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      if (!mounted) return;
      setState(() => _displayScore = (target * i / steps).toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    final gs = widget.gameState;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                    child: Text('📝', style: TextStyle(fontSize: 44))),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.6, 0.6)),
              const SizedBox(height: 16),
              // Mode label
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.secondary, width: 1.5),
                ),
                child: Text('WORD MODE',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary)),
              ).animate(delay: 50.ms).fadeIn(),
              const SizedBox(height: 12),
              Text('Game Over',
                      style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary))
                  .animate(delay: 100.ms)
                  .fadeIn()
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 24),
              // Score card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 24,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  children: [
                    if (_isNew)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('🏆 NEW BEST!',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                      ).animate().fadeIn().scale(),
                    Text('$_displayScore',
                        style: GoogleFonts.poppins(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondary)),
                    Text('YOUR SCORE',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            letterSpacing: 2,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.surface),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _StatChip(
                            label: 'Best',
                            value: '${gs.bestScore}',
                            icon: '🏆'),
                        _StatChip(
                            label: 'Words',
                            value: '${gs.totalCaught}',
                            icon: '📝'),
                        _StatChip(
                            label: 'Combo',
                            value: 'x${gs.maxCombo}',
                            icon: '🔥'),
                        _StatChip(
                            label: 'Accuracy',
                            value: '${gs.accuracy}%',
                            icon: '🎯'),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.4, end: 0),
              const SizedBox(height: 24),
              MenuButton(
                label: 'Play Again',
                icon: Icons.refresh_rounded,
                onTap: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const WordGameScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                  ),
                ),
                color: AppColors.secondary,
              ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.4, end: 0),
              const SizedBox(height: 14),
              MenuButton(
                label: 'Home',
                icon: Icons.home_rounded,
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                  (_) => false,
                ),
                color: AppColors.surface,
                textColor: AppColors.textPrimary,
              ).animate(delay: 430.ms).fadeIn().slideY(begin: 0.4, end: 0),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _StatChip(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 3),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
