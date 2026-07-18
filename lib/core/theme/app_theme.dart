import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.navy,
    colorScheme: const ColorScheme.light(
      primary: AppColors.navy,
      secondary: AppColors.blue,
      surface: AppColors.background,
      error: AppColors.orange,
    ),
    fontFamily: 'Arial',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.navy,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColors.navy,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(
        color: AppColors.navy,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColors.navy),
      bodyMedium: TextStyle(color: AppColors.navy),
      bodySmall: TextStyle(color: AppColors.navy),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.navy.withValues(alpha: .08),
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      color: AppColors.background,
      elevation: 0,
      shadowColor: AppColors.navy.withValues(alpha: .08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
    ),
  );
}
