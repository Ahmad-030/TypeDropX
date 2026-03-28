import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF4A90E2);
  static const secondary = Color(0xFF6FCF97);
  static const accent = Color(0xFFF2C94C);
  static const background = Color(0xFFF7F9FC);
  static const cardBg = Color(0xFFFFFFFF);
  static const surface = Color(0xFFEEF2F7);
  static const error = Color(0xFFEB5757);
  static const success = Color(0xFF27AE60);
  static const textPrimary = Color(0xFF2D3436);
  static const textSecondary = Color(0xFF828282);
  static const slowPowerUp = Color(0xFF74B9FF);
  static const blastPowerUp = Color(0xFFFF7675);
  static const magnetPowerUp = Color(0xFFA29BFE);
  static const lifePowerUp = Color(0xFF55EFC4);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
