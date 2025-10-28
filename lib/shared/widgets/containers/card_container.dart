import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Elevated card container with consistent styling
/// 
/// Features:
/// - Border: AppColors.border
/// - Rounded corners (12dp)
/// - Consistent padding
/// - Subtle shadow
/// - Optional tap interaction
/// - Optional header and footer sections
class CardContainer extends StatelessWidget {
  /// Card content
  final Widget child;
  
  /// Padding inside the card
  final EdgeInsetsGeometry? padding;
  
  /// Margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Border radius
  final double borderRadius;
  
  /// Card elevation (shadow depth)
  final double elevation;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// Optional border color override
  final Color? borderColor;
  
  /// Border width
  final double borderWidth;
  
  /// Optional tap callback
  final VoidCallback? onTap;
  
  /// Optional long press callback
  final VoidCallback? onLongPress;
  
  /// Width of the card
  final double? width;
  
  /// Height of the card
  final double? height;

  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  });

  /// Flat card without elevation
  const CardContainer.flat({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  }) : elevation = 0;

  /// Outlined card with no fill
  const CardContainer.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.borderColor,
    this.borderWidth = 1.5,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  })  : elevation = 0,
        backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.background;
    final effectiveBorderColor = borderColor ?? AppColors.border;
    final effectivePadding = padding ?? const EdgeInsets.all(16);
    
    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.08),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: child,
    );
    
    // Wrap with InkWell if tap callbacks are provided
    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }
    
    return card;
  }
}

/// Card with header, body, and optional footer
class SectionCard extends StatelessWidget {
  /// Card header widget
  final Widget? header;
  
  /// Card body content
  final Widget body;
  
  /// Card footer widget
  final Widget? footer;
  
  /// Padding inside the card
  final EdgeInsetsGeometry? padding;
  
  /// Margin around the card
  final EdgeInsetsGeometry? margin;
  
  /// Border radius
  final double borderRadius;
  
  /// Card elevation
  final double elevation;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// Optional border color override
  final Color? borderColor;
  
  /// Spacing between sections
  final double sectionSpacing;
  
  /// Whether to add dividers between sections
  final bool showDividers;

  const SectionCard({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.backgroundColor,
    this.borderColor,
    this.sectionSpacing = 16.0,
    this.showDividers = false,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) ...[
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: header,
            ),
            if (showDividers)
              Divider(
                height: 1,
                thickness: 1,
                color: borderColor ?? AppColors.border,
              )
            else
              SizedBox(height: sectionSpacing),
          ],
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: body,
          ),
          if (footer != null) ...[
            if (showDividers)
              Divider(
                height: 1,
                thickness: 1,
                color: borderColor ?? AppColors.border,
              )
            else
              SizedBox(height: sectionSpacing),
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: footer,
            ),
          ],
        ],
      ),
    );
  }
}

/// Info card with icon and content
class InfoCard extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Title text
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Optional trailing widget
  final Widget? trailing;
  
  /// Icon color
  final Color? iconColor;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Optional tap callback
  final VoidCallback? onTap;
  
  /// Padding inside the card
  final EdgeInsetsGeometry? padding;
  
  /// Margin around the card
  final EdgeInsetsGeometry? margin;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Stat card for displaying metrics
class StatCard extends StatelessWidget {
  /// Stat label
  final String label;
  
  /// Stat value
  final String value;
  
  /// Optional icon
  final IconData? icon;
  
  /// Optional trend indicator (positive/negative)
  final String? trend;
  
  /// Whether trend is positive
  final bool? isTrendPositive;
  
  /// Optional background color
  final Color? backgroundColor;
  
  /// Optional accent color
  final Color? accentColor;
  
  /// Padding inside the card
  final EdgeInsetsGeometry? padding;
  
  /// Margin around the card
  final EdgeInsetsGeometry? margin;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trend,
    this.isTrendPositive,
    this.backgroundColor,
    this.accentColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppColors.primary;
    
    return CardContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.withOpacity(0.7),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: effectiveAccentColor,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isTrendPositive == true
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 16,
                  color: isTrendPositive == true
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  trend!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isTrendPositive == true
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
