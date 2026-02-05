import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Theme Configuration
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryVariant,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onPrimary,
        onSurface: AppColors.onSurface,
        onError: AppColors.onError,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(color: AppColors.onBackground),
          headlineMedium: TextStyle(color: AppColors.onBackground),
          headlineSmall: TextStyle(color: AppColors.onBackground),
          titleLarge: TextStyle(color: AppColors.onBackground),
          titleMedium: TextStyle(color: AppColors.onBackground),
          titleSmall: TextStyle(color: AppColors.onBackground),
          bodyLarge: TextStyle(color: AppColors.onBackground),
          bodyMedium: TextStyle(color: AppColors.onBackground),
          bodySmall: TextStyle(color: AppColors.onSurfaceSecondary),
          labelLarge: TextStyle(color: AppColors.onBackground),
          labelMedium: TextStyle(color: AppColors.onSurfaceSecondary),
          labelSmall: TextStyle(color: AppColors.textSubtle),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.onBackground,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceVariant,
        thickness: 1,
      ),
    );
  }
}
