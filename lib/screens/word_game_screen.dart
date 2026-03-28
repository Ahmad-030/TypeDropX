import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word_game_state.dart';
import '../models/falling_word.dart';
import '../utils/app_theme.dart';
import '../widgets/falling_word_widget.dart';
import '../widgets/pause_overlay.dart';
import 'word_game_over_screen.dart';

class WordGameScreen extends StatefulWidget {
  const WordGameScreen({super.key});

  @override
  State<WordGameScreen> createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> {
  final WordGameState _gs = WordGameState();
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _gs.addListener(_onStateChange);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _gs.isPlaying && !_gs.isPaused && !_gs.isGameOver) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_focusNode.hasFocus) _focusNode.requestFocus();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gs.loadBestScore();
      _gs.startGame();
      _focusNode.requestFocus();
    });
  }

  void _onStateChange() {
    if (!mounted) return;
    if (_gs.isGameOver) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => WordGameOverScreen(gameState: _gs),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      });
    }
    if (mounted) setState(() {});
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) return;
    final last = value.characters.last.toUpperCase();
    if (RegExp(r'[A-Z]').hasMatch(last)) {
      _gs.onKeyTyped(last);
    }
    Future.microtask(() {
      if (mounted) _ctrl.clear();
    });
  }

  @override
  void dispose() {
    _gs.removeListener(_onStateChange);
    _gs.dispose();
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildHUD(),
                  Expanded(
                    child: Stack(
                      children: [
                        // Falling words
                        ..._gs.words.map((word) {
                          final isActive = word.id == _gs.activeWordId;
                          final typed = isActive ? _gs.currentInput : '';
                          return FallingWordWidget(
                            key: ValueKey(word.id),
                            word: word,
                            screenHeight: size.height,
                            screenWidth: size.width,
                            fallDuration: _gs.currentFallDuration,
                            onFell: _gs.onWordFell,
                            typedSoFar: typed,
                            isActive: isActive,
                          );
                        }),

                        // Combo badge
                        if (_gs.combo >= 2) _buildComboBadge(),

                        // Points burst
                        if (_gs.showPointsBurst) _buildPointsBurst(),

                        // Input display bar
                        _buildInputBar(),
                      ],
                    ),
                  ),
                  // Persistent keyboard anchor
                  SizedBox(
                    height: 1,
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focusNode,
                      onChanged: _onTextChanged,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      enableSuggestions: false,
                      showCursor: false,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                          color: Colors.transparent,
                          fontSize: 1,
                          height: 0.01),
                    ),
                  ),
                ],
              ),
            ),
            if (_gs.isPaused)
              PauseOverlay(
                onResume: _gs.resumeGame,
                onRestart: () {
                  _gs.resumeGame();
                  _gs.startGame();
                },
                onExit: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }

  // ── HUD ──────────────────────────────────────────────────

  Widget _buildHUD() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          // Lives
          Row(
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  i < _gs.lives
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: i < _gs.lives ? AppColors.error : AppColors.surface,
                  size: 22,
                ),
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${_gs.score}',
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary)),
              Text('SCORE',
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5)),
            ],
          ),
          const Spacer(),
          // Mode badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.secondary, width: 1.5),
            ),
            child: Text('WORD',
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary)),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _gs.isPaused ? _gs.resumeGame : _gs.pauseGame,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                  _gs.isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  color: AppColors.textPrimary,
                  size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input display bar at bottom of game area ─────────────

  Widget _buildInputBar() {
    final input = _gs.currentInput;
    final activeWord = _gs.activeWordId != null
        ? _gs.words
            .where((w) => w.id == _gs.activeWordId)
            .firstOrNull
        : null;

    return Positioned(
      bottom: 16,
      left: 20,
      right: 20,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activeWord != null
                ? activeWord.cardColor
                : AppColors.primary.withOpacity(0.3),
            width: activeWord != null ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.keyboard_alt_outlined,
                color: activeWord?.cardColor ?? AppColors.textSecondary,
                size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: input.isEmpty
                  ? Text('Start typing...',
                      style: GoogleFonts.poppins(
                          color: AppColors.textSecondary.withOpacity(0.5),
                          fontSize: 15))
                  : RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: input,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: activeWord?.cardColor ?? AppColors.primary,
                            ),
                          ),
                          if (activeWord != null &&
                              input.length < activeWord.word.length)
                            TextSpan(
                              text: activeWord.word.substring(input.length),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondary.withOpacity(0.3),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            // Backspace button
            GestureDetector(
              onTap: _gs.onBackspace,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.backspace_outlined,
                    color: AppColors.textSecondary, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboBadge() {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: AppColors.accent.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Text('🔥 COMBO x${_gs.combo}',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 500.ms),
      ),
    );
  }

  Widget _buildPointsBurst() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          '+${_gs.lastWordPoints}',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.success,
          ),
        )
            .animate()
            .fadeIn(duration: 150.ms)
            .slideY(begin: 0, end: -0.5, duration: 600.ms)
            .fadeOut(delay: 300.ms, duration: 300.ms),
      ),
    );
  }
}
