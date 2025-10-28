import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Icon size presets for consistent sizing
enum IconSize {
  small(16.0),
  medium(24.0),
  large(32.0),
  xLarge(48.0);

  const IconSize(this.value);
  final double value;
}

/// Themed icon widget with consistent size, color, and accessibility support
/// 
/// Features:
/// - Consistent sizing using IconSize presets
/// - Default color from AppColors.secondary
/// - Semantic labeling for screen readers
/// - Optional custom colors and sizes
/// - Support for both IconData and custom widgets
class ThemedIcon extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Size preset for the icon
  final IconSize size;
  
  /// Optional custom size (overrides size preset)
  final double? customSize;
  
  /// Optional color override (defaults to AppColors.secondary)
  final Color? color;
  
  /// Semantic label for accessibility (screen readers)
  final String? semanticLabel;
  
  /// Optional text direction for directional icons
  final TextDirection? textDirection;
  
  /// Optional shadow for elevated appearance
  final List<Shadow>? shadows;

  const ThemedIcon(
    this.icon, {
    super.key,
    this.size = IconSize.medium,
    this.customSize,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  });

  /// Small icon (16dp)
  const ThemedIcon.small(
    this.icon, {
    super.key,
    this.customSize,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  }) : size = IconSize.small;

  /// Medium icon (24dp) - default
  const ThemedIcon.medium(
    this.icon, {
    super.key,
    this.customSize,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  }) : size = IconSize.medium;

  /// Large icon (32dp)
  const ThemedIcon.large(
    this.icon, {
    super.key,
    this.customSize,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  }) : size = IconSize.large;

  /// Extra large icon (48dp)
  const ThemedIcon.xLarge(
    this.icon, {
    super.key,
    this.customSize,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  }) : size = IconSize.xLarge;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = customSize ?? size.value;
    final effectiveColor = color ?? AppColors.secondary;
    
    final iconWidget = Icon(
      icon,
      size: effectiveSize,
      color: effectiveColor,
      textDirection: textDirection,
      shadows: shadows,
    );
    
    // Wrap with Semantics if label is provided
    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        child: ExcludeSemantics(
          child: iconWidget,
        ),
      );
    }
    
    return iconWidget;
  }
}

/// Themed icon button with consistent styling and accessibility
class ThemedIconButton extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Size preset for the icon
  final IconSize size;
  
  /// Optional custom size (overrides size preset)
  final double? customSize;
  
  /// Optional color override (defaults to AppColors.secondary)
  final Color? color;
  
  /// Semantic label for accessibility (screen readers)
  final String? semanticLabel;
  
  /// Tooltip message
  final String? tooltip;
  
  /// Optional padding around the icon
  final EdgeInsetsGeometry? padding;
  
  /// Optional background color
  final Color? backgroundColor;
  
  /// Optional border radius
  final double? borderRadius;

  const ThemedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = IconSize.medium,
    this.customSize,
    this.color,
    this.semanticLabel,
    this.tooltip,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = customSize ?? size.value;
    final effectiveColor = color ?? AppColors.secondary;
    
    Widget button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: effectiveSize,
      color: effectiveColor,
      padding: padding ?? const EdgeInsets.all(8.0),
      tooltip: tooltip ?? semanticLabel,
      style: backgroundColor != null
          ? IconButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
              ),
            )
          : null,
    );
    
    // Add semantic label if provided and different from tooltip
    if (semanticLabel != null && semanticLabel != tooltip) {
      button = Semantics(
        label: semanticLabel,
        button: true,
        enabled: onPressed != null,
        child: ExcludeSemantics(child: button),
      );
    }
    
    return button;
  }
}
