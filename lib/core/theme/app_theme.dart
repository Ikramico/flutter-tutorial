// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

// ── Colour palette ────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  static const primary = Color(0xFF5C35D4);
  static const accent = Color(0xFF8B5CF6);
  static const secondary = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);

  // Grades
  static const gradeS = Color(0xFFFFD700);
  static const gradeA = Color(0xFF10B981);
  static const gradeB = Color(0xFF0EA5E9);
  static const gradeC = Color(0xFFF59E0B);
  static const gradeF = Color(0xFFEF4444);

  // Surface
  static const background = Color(0xFFF5F3FF);
  static const card = Color(0xFFFFFFFF);
  static const divider = Color(0xFFE8E3FA);

  // Text
  static const textPrimary = Color(0xFF1A1730);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);

  // Gradients
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF5C35D4), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientQuiz = LinearGradient(
    colors: [Color(0xFF1E1245), Color(0xFF3D2A8A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientResult = LinearGradient(
    colors: [Color(0xFF1E1245), Color(0xFF5C35D4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Returns the colour for a quiz grade string.
  static Color forGrade(String grade) {
    switch (grade) {
      case 'S':
        return gradeS;
      case 'A':
        return gradeA;
      case 'B':
        return gradeB;
      case 'C':
        return gradeC;
      default:
        return gradeF;
    }
  }
}

// ── Text styles ───────────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  static const h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );
}

// ── ThemeData ─────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: false,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      indicatorColor: Colors.white,
    ),
  );
}
