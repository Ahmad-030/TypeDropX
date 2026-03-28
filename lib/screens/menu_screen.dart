import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../widgets/floating_letters_bg.dart';
import '../widgets/menu_button.dart';
import '../models/game_state.dart';
import 'game_screen.dart';
import 'word_game_screen.dart';
import 'high_score_screen.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final GameState _gameState = GameState();

  @override
  void initState() {
    super.initState();
    _gameState.loadBestScore();
  }

  @override
  void dispose() {
    _gameState.dispose();
    super.dispose();
  }

  void _goPlay() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => GameScreen(gameState: _gameState),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ).then((_) {
      _gameState.loadBestScore();
      setState(() {});
    });
  }

  void _goWordMode() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const WordGameScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const FloatingLettersBg(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Logo
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('T⬇',
                              style: TextStyle(
                                  fontSize: 38, color: Colors.white)),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                      const SizedBox(height: 14),
                      Text(
                        'TypeDrop X',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3, end: 0),
                      Text(
                        'Type Fast. Think Faster.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate(delay: 150.ms).fadeIn(),
                      const SizedBox(height: 32),

                      // ── Game Mode Section ──────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'GAME MODES',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ).animate(delay: 180.ms).fadeIn(),
                      const SizedBox(height: 10),

                      // Letter Mode card
                      _ModeCard(
                        delay: 200,
                        icon: '🔤',
                        title: 'Letter Mode',
                        subtitle: 'Catch falling letters before they hit the ground',
                        color: AppColors.primary,
                        onTap: _goPlay,
                      ),
                      const SizedBox(height: 12),

                      // Word Mode card
                      _ModeCard(
                        delay: 280,
                        icon: '📝',
                        title: 'Word Mode',
                        subtitle: 'Type full words — harder, higher scores!',
                        color: AppColors.secondary,
                        onTap: _goWordMode,
                        badgeText: 'NEW',
                      ),

                      const SizedBox(height: 24),

                      // ── Other buttons ─────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'MORE',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ).animate(delay: 340.ms).fadeIn(),
                      const SizedBox(height: 10),

                      MenuButton(
                        label: 'High Score',
                        icon: Icons.emoji_events_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  HighScoreScreen(gameState: _gameState)),
                        ),
                        color: AppColors.accent,
                        textColor: AppColors.textPrimary,
                      ).animate(delay: 360.ms).fadeIn().slideY(begin: 0.4, end: 0),
                      const SizedBox(height: 12),
                      MenuButton(
                        label: 'About',
                        icon: Icons.info_outline_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AboutScreen()),
                        ),
                        color: AppColors.surface,
                        textColor: AppColors.textPrimary,
                      ).animate(delay: 420.ms).fadeIn().slideY(begin: 0.4, end: 0),
                      const SizedBox(height: 12),
                      MenuButton(
                        label: 'Privacy Policy',
                        icon: Icons.lock_outline_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen()),
                        ),
                        color: AppColors.surface,
                        textColor: AppColors.textPrimary,
                      ).animate(delay: 480.ms).fadeIn().slideY(begin: 0.4, end: 0),

                      const Spacer(),
                      Text(
                        'v1.0.0  •  Developed by Ahmad Asif',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textSecondary),
                      ).animate(delay: 600.ms).fadeIn(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mode Card Widget ───────────────────────────────────────

class _ModeCard extends StatefulWidget {
  final int delay;
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final String? badgeText;

  const _ModeCard({
    required this.delay,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.badgeText,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: 0.97,
        upperBound: 1.0,
        value: 1.0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _ctrl.value, child: child),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: widget.color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                    child: Text(widget.icon,
                        style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.title,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        if (widget.badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(widget.badgeText!,
                                style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(widget.subtitle,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: widget.color, size: 16),
            ],
          ),
        ),
      ),
    ).animate(delay: widget.delay.ms).fadeIn().slideY(begin: 0.4, end: 0);
  }
}
