import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Themed divider component for visual separation
/// 
/// Features:
/// - Thin line with AppColors.border
/// - Height: 0.5-1dp
/// - Full-width or inset variants
/// - Horizontal and vertical orientations
/// - Optional custom thickness and color
class ThemedDivider extends StatelessWidget {
  /// Divider thickness (height for horizontal, width for vertical)
  final double thickness;
  
  /// Optional color override
  final Color? color;
  
  /// Indent from the start edge
  final double indent;
  
  /// Indent from the end edge
  final double endIndent;
  
  /// Empty space above and below (for horizontal) or left and right (for vertical)
  final double spacing;

  const ThemedDivider({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.spacing = 0,
  });

  /// Full-width divider (no insets)
  const ThemedDivider.fullWidth({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.spacing = 0,
  })  : indent = 0,
        endIndent = 0;

  /// Inset divider with padding on both sides
  const ThemedDivider.inset({
    super.key,
    this.thickness = 1.0,
    this.color,
    double inset = 16.0,
    this.spacing = 0,
  })  : indent = inset,
        endIndent = inset;

  /// Thin divider (0.5dp)
  const ThemedDivider.thin({
    super.key,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.spacing = 0,
  }) : thickness = 0.5;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      color: color ?? AppColors.border,
      indent: indent,
      endIndent: endIndent,
      height: spacing > 0 ? spacing : thickness,
    );
  }
}

/// Vertical divider for separating content horizontally
class ThemedVerticalDivider extends StatelessWidget {
  /// Divider thickness (width)
  final double thickness;
  
  /// Optional color override
  final Color? color;
  
  /// Indent from the top edge
  final double indent;
  
  /// Indent from the bottom edge
  final double endIndent;
  
  /// Empty space left and right
  final double spacing;

  const ThemedVerticalDivider({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.spacing = 0,
  });

  /// Full-height vertical divider
  const ThemedVerticalDivider.fullHeight({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.spacing = 0,
  })  : indent = 0,
        endIndent = 0;

  /// Thin vertical divider (0.5dp)
  const ThemedVerticalDivider.thin({
    super.key,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.spacing = 0,
  }) : thickness = 0.5;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      thickness: thickness,
      color: color ?? AppColors.border,
      indent: indent,
      endIndent: endIndent,
      width: spacing > 0 ? spacing : thickness,
    );
  }
}

/// Section divider with optional label
class SectionDivider extends StatelessWidget {
  /// Optional label text
  final String? label;
  
  /// Divider thickness
  final double thickness;
  
  /// Optional color override
  final Color? color;
  
  /// Spacing around the divider
  final double spacing;

  const SectionDivider({
    super.key,
    this.label,
    this.thickness = 1.0,
    this.color,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing),
        child: ThemedDivider(
          thickness: thickness,
          color: color,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Row(
        children: [
          Expanded(
            child: ThemedDivider(
              thickness: thickness,
              color: color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: (color ?? AppColors.border).withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: ThemedDivider(
              thickness: thickness,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
