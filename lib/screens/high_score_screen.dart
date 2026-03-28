import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_state.dart';
import '../models/word_game_state.dart';
import '../utils/app_theme.dart';

class HighScoreScreen extends StatefulWidget {
  final GameState gameState;
  final WordGameState wordGameState;

  const HighScoreScreen({
    super.key,
    required this.gameState,
    required this.wordGameState,
  });

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Letter mode animated counters
  int _lScore = 0;
  int _lLetters = 0;
  int _lCombo = 0;

  // Word mode animated counters
  int _wScore = 0;
  int _wWords = 0;
  int _wCombo = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animateCounters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _animateCounters() async {
    final gs = widget.gameState;
    final wgs = widget.wordGameState;
    const steps = 25;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 28));
      if (!mounted) return;
      setState(() {
        _lScore = (gs.bestScore * i / steps).toInt();
        _lLetters = (gs.totalLettersAllTime * i / steps).toInt();
        _lCombo = (gs.bestComboAllTime * i / steps).toInt();
        _wScore = (wgs.bestScore * i / steps).toInt();
        _wWords = (wgs.totalWordsAllTime * i / steps).toInt();
        _wCombo = (wgs.bestComboAllTime * i / steps).toInt();
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: '🔤  Letter Mode'),
            Tab(text: '📝  Word Mode'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LetterModeStats(
            displayScore: _lScore,
            displayLetters: _lLetters,
            displayCombo: _lCombo,
            accuracy: widget.gameState.accuracy,
          ),
          _WordModeStats(
            displayScore: _wScore,
            displayWords: _wWords,
            displayCombo: _wCombo,
            accuracy: widget.wordGameState.accuracy,
          ),
        ],
      ),
    );
  }
}

// ── Letter Mode Tab ───────────────────────────────────────

class _LetterModeStats extends StatelessWidget {
  final int displayScore;
  final int displayLetters;
  final int displayCombo;
  final int accuracy;

  const _LetterModeStats({
    required this.displayScore,
    required this.displayLetters,
    required this.displayCombo,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 46)),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.7, 0.7)),
            ),
            const SizedBox(height: 28),
            _StatCard(
              label: 'BEST SCORE',
              value: '$displayScore',
              icon: Icons.star_rounded,
              color: AppColors.primary,
              delay: 100,
            ),
            const SizedBox(height: 14),
            _StatCard(
              label: 'TOTAL LETTERS CAUGHT',
              value: '$displayLetters',
              icon: Icons.keyboard_rounded,
              color: AppColors.secondary,
              delay: 200,
            ),
            const SizedBox(height: 14),
            _StatCard(
              label: 'BEST COMBO',
              value: 'x$displayCombo',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.accent,
              delay: 300,
            ),
            const SizedBox(height: 14),
            _StatCard(
              label: 'ACCURACY',
              value: '$accuracy%',
              icon: Icons.gps_fixed_rounded,
              color: AppColors.magnetPowerUp,
              delay: 400,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Word Mode Tab ─────────────────────────────────────────

class _WordModeStats extends StatelessWidget {
  final int displayScore;
  final int displayWords;
  final int displayCombo;
  final int accuracy;

  const _WordModeStats({
    required this.displayScore,
    required this.displayWords,
    required this.displayCombo,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Center(
                  child: Text('📝', style: TextStyle(fontSize: 46)),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.7, 0.7)),
            ),
            const SizedBox(height: 28),
            _StatCard(
              label: 'BEST SCORE',
              value: '$displayScore',
              icon: Icons.star_rounded,
              color: AppColors.secondary,
              delay: 100,
            ),
            const SizedBox(height: 14),
            _StatCard(
              label: 'TOTAL WORDS TYPED',
              value: '$displayWords',
              icon: Icons.spellcheck_rounded,
              color: AppColors.primary,
              delay: 200,
            ),
            const SizedBox(height: 14),
            _StatCard(
              label: 'BEST COMBO',
              value: 'x$displayCombo',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.accent,
              delay: 300,
            ),
            const SizedBox(height: 14),
            _StatCard(
              label: 'ACCURACY',
              value: '$accuracy%',
              icon: Icons.gps_fixed_rounded,
              color: AppColors.magnetPowerUp,
              delay: 400,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared stat card ──────────────────────────────────────

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