import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Typography variants for consistent text styling
enum TextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  captionLarge,
  captionMedium,
  captionSmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// Themed text widget with automatic RTL support, dynamic color, and text scaling
/// 
/// Provides a comprehensive typography system with:
/// - Display: Large, prominent text (32-24px)
/// - Headline: Section headers (22-18px)
/// - Title: Card/list titles (18-14px)
/// - Body: Main content text (16-12px)
/// - Caption: Supporting text (12-10px)
/// - Label: UI labels and buttons (14-11px)
/// 
/// Features:
/// - Automatic RTL text alignment based on locale
/// - Dynamic color from AppColors.text
/// - Text scaling support for accessibility
/// - Semantic text rendering
class ThemedText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Typography variant to use
  final TextVariant variant;
  
  /// Optional color override (defaults to AppColors.text or variant-specific color)
  final Color? color;
  
  /// Optional font weight override
  final FontWeight? fontWeight;
  
  /// Text alignment (auto-detects RTL if null)
  final TextAlign? textAlign;
  
  /// Maximum number of lines before truncating
  final int? maxLines;
  
  /// How to handle text overflow
  final TextOverflow? overflow;
  
  /// Optional text decoration (underline, strikethrough, etc.)
  final TextDecoration? decoration;
  
  /// Optional height multiplier for line spacing
  final double? height;
  
  /// Optional letter spacing
  final double? letterSpacing;

  const ThemedText(
    this.text, {
    super.key,
    this.variant = TextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  });

  /// Display variant constructors for convenience
  const ThemedText.displayLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.displayLarge;

  const ThemedText.displayMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.displayMedium;

  const ThemedText.displaySmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.displaySmall;

  /// Headline variant constructors
  const ThemedText.headlineLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.headlineLarge;

  const ThemedText.headlineMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.headlineMedium;

  const ThemedText.headlineSmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.headlineSmall;

  /// Title variant constructors
  const ThemedText.titleLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.titleLarge;

  const ThemedText.titleMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.titleMedium;

  const ThemedText.titleSmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.titleSmall;

  /// Body variant constructors
  const ThemedText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.bodyLarge;

  const ThemedText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.bodyMedium;

  const ThemedText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.bodySmall;

  /// Caption variant constructors
  const ThemedText.captionLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.captionLarge;

  const ThemedText.captionMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.captionMedium;

  const ThemedText.captionSmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.captionSmall;

  /// Label variant constructors
  const ThemedText.labelLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.labelLarge;

  const ThemedText.labelMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.labelMedium;

  const ThemedText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
  }) : variant = TextVariant.labelSmall;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    // Get base style from variant
    TextStyle baseStyle = _getStyleFromVariant(textTheme);
    
    // Apply overrides
    final effectiveStyle = baseStyle.copyWith(
      color: color,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      letterSpacing: letterSpacing,
    );
    
    // Auto-detect text alignment for RTL
    final effectiveTextAlign = textAlign ?? (isRTL ? TextAlign.right : TextAlign.left);
    
    return Text(
      text,
      style: effectiveStyle,
      textAlign: effectiveTextAlign,
      maxLines: maxLines,
      overflow: overflow,
      textScaler: MediaQuery.textScalerOf(context),
    );
  }

  /// Maps variant to theme text style
  TextStyle _getStyleFromVariant(TextTheme textTheme) {
    switch (variant) {
      // Display variants
      case TextVariant.displayLarge:
        return textTheme.displayLarge ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.secondary);
      case TextVariant.displayMedium:
        return textTheme.displayMedium ?? const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary);
      case TextVariant.displaySmall:
        return textTheme.displaySmall ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary);
      
      // Headline variants
      case TextVariant.headlineLarge:
        return textTheme.headlineLarge ?? const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.secondary);
      case TextVariant.headlineMedium:
        return textTheme.headlineMedium ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary);
      case TextVariant.headlineSmall:
        return textTheme.headlineSmall ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.secondary);
      
      // Title variants
      case TextVariant.titleLarge:
        return textTheme.titleLarge ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.text);
      case TextVariant.titleMedium:
        return textTheme.titleMedium ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.text);
      case TextVariant.titleSmall:
        return textTheme.titleSmall ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text);
      
      // Body variants
      case TextVariant.bodyLarge:
        return textTheme.bodyLarge ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.text);
      case TextVariant.bodyMedium:
        return textTheme.bodyMedium ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.text);
      case TextVariant.bodySmall:
        return textTheme.bodySmall ?? const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.text);
      
      // Caption variants
      case TextVariant.captionLarge:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.text);
      case TextVariant.captionMedium:
        return const TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: AppColors.text);
      case TextVariant.captionSmall:
        return const TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: AppColors.text);
      
      // Label variants
      case TextVariant.labelLarge:
        return textTheme.labelLarge ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text);
      case TextVariant.labelMedium:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.text);
      case TextVariant.labelSmall:
        return const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.text);
    }
  }
}
