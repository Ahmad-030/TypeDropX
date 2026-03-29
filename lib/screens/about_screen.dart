import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('T⬇', style: TextStyle(fontSize: 44, color: Colors.white)),
                ),
              ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 20),
              Text(
                'TypeDrop X',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ).animate(delay: 100.ms).fadeIn(),

              const SizedBox(height: 28),

              // Description card
              _InfoCard(
                delay: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About the Game',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'TypeDrop X is a fast-paced arcade typing game built to sharpen your reflexes and keyboard speed. Letters and words rain down the screen — type them before they hit the bottom, chain combos to multiply your score, and grab power-ups to turn the tide!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Game Modes card
              _InfoCard(
                delay: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Game Modes',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ModeLine(
                      icon: '🔤',
                      name: 'Letter Mode',
                      desc: 'Single falling letters — press the matching key to catch them. Speed ramps up every 5 catches.',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    _ModeLine(
                      icon: '📝',
                      name: 'Word Mode',
                      desc: 'Type out full falling words. Easy, Medium, and Hard words spawn as you progress.',
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Scoring card
              _InfoCard(
                delay: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scoring & Combos',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ScoreLine('🎯', 'Base',    'Letter Mode: 10 pts · Word Mode: per letter × difficulty'),
                    _ScoreLine('🔥', 'Combo x1.5', '3+ catches in a row'),
                    _ScoreLine('🔥', 'Combo x2',   '5+ catches in a row'),
                    _ScoreLine('🔥', 'Combo x3',   '10+ catches in a row'),
                    _ScoreLine('💔', 'Miss',    'Combo resets — lose 1 life'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Power-ups card
              _InfoCard(
                delay: 380,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Power-Ups  (Letter Mode)',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PowerLine('🐢', 'Slow Mo',    'Halves fall speed for 5 sec'),
                    _PowerLine('💥', 'Blast',      'Instantly clears all letters on screen'),
                    _PowerLine('🧲', 'Magnet',     'Auto-catches every letter for 5 sec'),
                    _PowerLine('❤️', 'Extra Life', 'Restores 1 life (max 3)'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Developer card
              _InfoCard(
                delay: 440,
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('👨‍💻', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edocutopp',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Developer & Designer',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'whitesamuelkoma@gmail.com',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final Widget child;
  final int delay;
  const _InfoCard({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    ).animate(delay: delay.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}

class _ModeLine extends StatelessWidget {
  final String icon;
  final String name;
  final String desc;
  final Color color;
  const _ModeLine({required this.icon, required this.name, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              Text(desc,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PowerLine extends StatelessWidget {
  final String emoji;
  final String name;
  final String desc;
  const _PowerLine(this.emoji, this.name, this.desc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '— $desc',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreLine extends StatelessWidget {
  final String emoji;
  final String name;
  final String desc;
  const _ScoreLine(this.emoji, this.name, this.desc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(name,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.textPrimary)),
          const SizedBox(width: 6),
          Expanded(
            child: Text('— $desc',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}