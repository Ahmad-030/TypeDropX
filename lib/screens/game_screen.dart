import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_state.dart';
import '../utils/app_theme.dart';
import '../utils/game_constants.dart';
import '../widgets/falling_letter_widget.dart';
import '../widgets/pause_overlay.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  final GameState gameState;
  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameState _gs;
  final TextEditingController _textCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _lastPowerUp;
  bool _showPowerUpBanner = false;

  @override
  void initState() {
    super.initState();
    _gs = widget.gameState;
    _gs.addListener(_onStateChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gs.startGame();
      _focusNode.requestFocus();
    });

    // Re-request focus if it's ever lost
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _gs.isPlaying && !_gs.isPaused && !_gs.isGameOver) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
        });
      }
    });
  }

  void _onStateChange() {
    if (!mounted) return;
    if (_gs.isGameOver) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => GameOverScreen(gameState: _gs),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      });
    }
    if (_gs.lastPowerUpType != null && _gs.lastPowerUpType != _lastPowerUp) {
      _lastPowerUp = _gs.lastPowerUpType;
      setState(() => _showPowerUpBanner = true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _showPowerUpBanner = false);
      });
    }
    if (mounted) setState(() {});
  }

  void _onKeyTyped(String value) {
    if (value.isEmpty) return;
    // Extract last character typed
    final typed = value.characters.last.toUpperCase();
    _gs.onKeyTyped(typed);

    // Clear without losing focus — schedule after current frame
    Future.microtask(() {
      if (mounted) {
        _textCtrl.clear();
      }
    });
  }

  @override
  void dispose() {
    _gs.removeListener(_onStateChange);
    _textCtrl.dispose();
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
                        // Falling letters
                        ..._gs.letters.map((letter) => FallingLetterWidget(
                              key: ValueKey(letter.id),
                              letter: letter,
                              screenHeight: size.height,
                              screenWidth: size.width,
                              fallDuration: _gs.currentFallDuration,
                              onFell: _gs.onLetterFell,
                            )),
                        // Combo badge
                        if (_gs.combo >= GameConstants.comboThreshold)
                          _buildComboBadge(),
                        // Power-up banner
                        if (_showPowerUpBanner) _buildPowerUpBanner(),
                        // Active power-up indicator
                        if (_gs.isSlowActive || _gs.isMagnetActive)
                          _buildActivePowerIndicator(),
                      ],
                    ),
                  ),
                  // ── Visible keyboard anchor at the bottom ──
                  // This TextField is always IN the layout tree so Android
                  // never decides to close the keyboard. It's 1px tall and
                  // completely transparent — the user never sees it.
                  SizedBox(
                    height: 1,
                    child: TextField(
                      controller: _textCtrl,
                      focusNode: _focusNode,
                      onChanged: _onKeyTyped,
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
                        height: 0.01,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Pause overlay
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

  Widget _buildHUD() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
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
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_gs.score}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'SCORE',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Pause button
          GestureDetector(
            onTap: _gs.isPaused ? _gs.resumeGame : _gs.pauseGame,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _gs.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
        ],
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
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '🔥 COMBO x${_gs.combo}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: 500.ms,
            ),
      ),
    );
  }

  Widget _buildPowerUpBanner() {
    final type = PowerType.values.firstWhere(
      (e) => e.name == _lastPowerUp,
      orElse: () => PowerType.blast,
    );
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(GameConstants.powerUpEmoji[type]!,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                GameConstants.powerUpLabel[type]!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.3, end: 0),
      ),
    );
  }

  Widget _buildActivePowerIndicator() {
    final label = _gs.isSlowActive ? '🐢 SLOW MO ACTIVE' : '🧲 MAGNET ACTIVE';
    final color =
        _gs.isSlowActive ? AppColors.slowPowerUp : AppColors.magnetPowerUp;
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
