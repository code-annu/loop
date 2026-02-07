import 'package:flutter/material.dart';

/// App Color Constants
/// Dark theme color palette for music streaming app
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1DB954); // Spotify-like green
  static const Color primaryVariant = Color(0xFF1ED760);
  static const Color onPrimary = Color(0xFF000000);

  // Background Colors
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF282828);
  static const Color surfaceContainerHighest = Color(0xFF333333);
  static const Color card = Color(0xFF181818);

  // Text Colors
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceSecondary = Color(0xFFB3B3B3);
  static const Color onSurfaceVariant = Color(0xFFCAC4D0);
  static const Color textSubtle = Color(0xFF727272);

  // Status Colors
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF000000);
  static const Color success = Color(0xFF1DB954);
  static const Color warning = Color(0xFFFFB800);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF1DB954),
    Color(0xFF191414),
  ];

  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);
}
