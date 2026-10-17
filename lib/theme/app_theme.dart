import 'package:flutter/material.dart';

/// Palet warna yang dipakai di seluruh aplikasi.
class AppColors {
  static const Color primary = Color(0xFFD4500A);
  static const Color primaryLight = Color(0xFFE8703A);
  static const Color primaryDark = Color(0xFFB23D00);
  static const Color background = Color(0xFFFFF8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFF8F3);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFF0E8E0);
  static const Color star = Color(0xFFFFB800);
  static const Color green = Color(0xFF27AE60);
  static const Color red = Color(0xFFE74C3C);
  static const Color badgeTerlaris = Color(0xFFD4500A);
  static const Color badgeHemat = Color(0xFF27AE60);
  static const Color badgeSegar = Color(0xFF2980B9);
}

/// Bayangan (shadow) standar agar dekorasi konsisten dan tidak ditulis berulang.
class AppShadows {
  const AppShadows._();

  /// Bayangan hitam lembut. Nilai bawaan sama dengan `blur: 6, offset: (0, 2)`.
  static BoxShadow black({
    double alpha = 0.06,
    double blur = 6,
    double dy = 2,
  }) => BoxShadow(
    color: Colors.black.withValues(alpha: alpha),
    blurRadius: blur,
    offset: Offset(0, dy),
  );

  /// Bayangan berwarna primary untuk elemen yang menonjol.
  static BoxShadow primary({
    double alpha = 0.3,
    double blur = 8,
    double dy = 3,
  }) => BoxShadow(
    color: AppColors.primary.withValues(alpha: alpha),
    blurRadius: blur,
    offset: Offset(0, dy),
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get theme => ThemeData(
    fontFamily: 'sans-serif',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.textPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
  );
}
