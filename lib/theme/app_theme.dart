import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central brand definition mirroring the original Tailwind config.
class AppColors {
  static const primary = Color(0xFF2563EB); // blue-600
  static const secondary = Color(0xFF4F46E5); // indigo-600
  static const increase = Color(0xFFEF4444); // red-500
  static const decrease = Color(0xFF10B981); // emerald-500

  // Light
  static const lightBg = Color(0xFFF8FAFC); // slate-50
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2E8F0); // slate-200
  static const lightText = Color(0xFF0F172A); // slate-900
  static const lightMuted = Color(0xFF64748B); // slate-500

  // Dark
  static const darkBg = Color(0xFF020617); // slate-950
  static const darkSurface = Color(0xFF0F172A); // slate-900
  static const darkBorder = Color(0xFF1E293B); // slate-800
  static const darkText = Color(0xFFF8FAFC);
  static const darkMuted = Color(0xFF94A3B8); // slate-400
}

class AppTheme {
  static TextTheme _arabic(TextTheme base, Color color) =>
      GoogleFonts.ibmPlexSansArabicTextTheme(base).apply(
        bodyColor: color,
        displayColor: color,
      );

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        surface: AppColors.lightSurface,
      ),
      textTheme: _arabic(base.textTheme, AppColors.lightText),
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightBorder,
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        surface: AppColors.darkSurface,
      ),
      textTheme: _arabic(base.textTheme, AppColors.darkText),
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkBorder,
    );
  }
}

/// Convenience getters that respect the active brightness.
extension ThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get surface => isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get bg => isDark ? AppColors.darkBg : AppColors.lightBg;
  Color get border => isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get textColor => isDark ? AppColors.darkText : AppColors.lightText;
  Color get muted => isDark ? AppColors.darkMuted : AppColors.lightMuted;
}
