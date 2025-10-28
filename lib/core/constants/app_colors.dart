import 'package:flutter/material.dart';

/// Clash Display Color Palette
/// Modern, accessible colors with WCAG AA compliance
class AppColors {
  AppColors._();

  /// Primary - Light Blue (#7BBBFF)
  /// Used for: actions, highlights, CTAs, active states
  static const Color primary = Color(0xFF7BBBFF);

  /// Secondary - Deep Navy (#050F2A)
  /// Used for: headers, icons, primary text
  static const Color secondary = Color(0xFF050F2A);

  /// Accent - Lavender (#B8A9FF)
  /// Used for: tags, badges, secondary info, interactive elements
  static const Color accent = Color(0xFFB8A9FF);

  /// Text - Deep Navy (#050F2A)
  /// Same as secondary for high contrast body text
  static const Color text = Color(0xFF050F2A);

  /// Border - Off-White (#F2FDFF)
  /// Used for: dividers, input borders, subtle separators
  static const Color border = Color(0xFFF2FDFF);

  /// Background - Pure White (#FFFFFF)
  /// Main background color
  static const Color background = Color(0xFFFFFFFF);

  /// Error color for validation and alerts
  static const Color error = Color(0xFFD32F2F);

  /// Success color for confirmations
  static const Color success = Color(0xFF388E3C);

  /// Warning color for cautions
  static const Color warning = Color(0xFFF57C00);
}
