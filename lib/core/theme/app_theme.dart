import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      fontFamily: 'AT Hauss Arabic',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primary),
        titleTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'AT Hauss Arabic',
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(color: AppColors.primary, fontWeight: FontWeight.normal),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 1,
        shadowColor: AppColors.primary.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
