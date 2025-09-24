import 'package:flutter/material.dart';

class MarketplaceThemeExtension extends ThemeExtension<MarketplaceThemeExtension> {
  final double cardElevation;
  final double borderRadius;
  final AppSpacing spacing;

  MarketplaceThemeExtension({
    required this.cardElevation,
    required this.borderRadius,
    required this.spacing,
  });

  @override
  MarketplaceThemeExtension copyWith({
    double? cardElevation,
    double? borderRadius,
    AppSpacing? spacing,
  }) {
    return MarketplaceThemeExtension(
      cardElevation: cardElevation ?? this.cardElevation,
      borderRadius: borderRadius ?? this.borderRadius,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  MarketplaceThemeExtension lerp(ThemeExtension<MarketplaceThemeExtension>? other, double t) {
    if (other is! MarketplaceThemeExtension) {
      return this;
    }
    return MarketplaceThemeExtension(
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t) ?? cardElevation,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      spacing: spacing.lerp(other.spacing, t),
    );
  }

  static double? lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }
}

class AppSpacing {
  final double xs = 4.0;
  final double sm = 8.0;
  final double md = 16.0;
  final double lg = 24.0;
  final double xl = 32.0;
  final double xxl = 48.0;

  AppSpacing lerp(AppSpacing other, double t) {
    // Since these are constants, we don't actually lerp them
    return t < 0.5 ? this : other;
  }
}