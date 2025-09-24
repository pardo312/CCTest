import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'marketplace_theme_extension.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ??
          ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      extensions: [
        MarketplaceThemeExtension(
          cardElevation: 2,
          borderRadius: 12,
          spacing: AppSpacing(),
        ),
      ],
    );
  }

  static ThemeData darkTheme(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ??
          ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: const CardTheme(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      extensions: [
        MarketplaceThemeExtension(
          cardElevation: 4,
          borderRadius: 12,
          spacing: AppSpacing(),
        ),
      ],
    );
  }
}