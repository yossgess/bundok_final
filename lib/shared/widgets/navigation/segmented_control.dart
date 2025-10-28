import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// iOS-style segmented control component
/// 
/// Features:
/// - iOS-style tabs: "All", "Paid", "Unpaid"
/// - Works on Android with custom paint
/// - Smooth animations
/// - Customizable colors and styling
/// - Optional icons
class SegmentedControl<T> extends StatelessWidget {
  /// List of segments
  final List<Segment<T>> segments;
  
  /// Currently selected segment value
  final T selectedValue;
  
  /// Callback when segment is selected
  final ValueChanged<T>? onValueChanged;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Selected segment color
  final Color? selectedColor;
  
  /// Unselected text color
  final Color? unselectedColor;
  
  /// Border radius
  final double borderRadius;
  
  /// Padding inside the control
  final EdgeInsetsGeometry? padding;
  
  /// Height of the control
  final double? height;

  const SegmentedControl({
    super.key,
    required this.segments,
    required this.selectedValue,
    this.onValueChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = 8.0,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        AppColors.border.withOpacity(0.3);
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;
    final effectiveUnselectedColor = unselectedColor ?? AppColors.secondary;

    return Container(
      height: height ?? 40,
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          final isSelected = segment.value == selectedValue;
          final isFirst = index == 0;
          final isLast = index == segments.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: onValueChanged != null 
                  ? () => onValueChanged!(segment.value) 
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? effectiveSelectedColor 
                      : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(isFirst ? borderRadius - 4 : 0),
                    right: Radius.circular(isLast ? borderRadius - 4 : 0),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: effectiveSelectedColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (segment.icon != null) ...[
                        Icon(
                          segment.icon,
                          size: 16,
                          color: isSelected 
                              ? Colors.white 
                              : effectiveUnselectedColor,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        segment.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.w500,
                          color: isSelected 
                              ? Colors.white 
                              : effectiveUnselectedColor,
                        ),
                      ),
                      if (segment.badgeCount != null && segment.badgeCount! > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Colors.white.withOpacity(0.3) 
                                : AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            segment.badgeCount! > 99 
                                ? '99+' 
                                : segment.badgeCount.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? Colors.white 
                                  : effectiveUnselectedColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Segment data model
class Segment<T> {
  final T value;
  final String label;
  final IconData? icon;
  final int? badgeCount;

  const Segment({
    required this.value,
    required this.label,
    this.icon,
    this.badgeCount,
  });
}

/// Vertical segmented control variant
class VerticalSegmentedControl<T> extends StatelessWidget {
  /// List of segments
  final List<Segment<T>> segments;
  
  /// Currently selected segment value
  final T selectedValue;
  
  /// Callback when segment is selected
  final ValueChanged<T>? onValueChanged;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Selected segment color
  final Color? selectedColor;
  
  /// Unselected text color
  final Color? unselectedColor;
  
  /// Border radius
  final double borderRadius;
  
  /// Padding inside the control
  final EdgeInsetsGeometry? padding;

  const VerticalSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedValue,
    this.onValueChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = 8.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        AppColors.border.withOpacity(0.3);
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;
    final effectiveUnselectedColor = unselectedColor ?? AppColors.secondary;

    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          final isSelected = segment.value == selectedValue;
          final isFirst = index == 0;
          final isLast = index == segments.length - 1;

          return GestureDetector(
            onTap: onValueChanged != null 
                ? () => onValueChanged!(segment.value) 
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : 4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? effectiveSelectedColor 
                    : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isFirst ? borderRadius - 4 : 0),
                  bottom: Radius.circular(isLast ? borderRadius - 4 : 0),
                ),
              ),
              child: Row(
                children: [
                  if (segment.icon != null) ...[
                    Icon(
                      segment.icon,
                      size: 18,
                      color: isSelected 
                          ? Colors.white 
                          : effectiveUnselectedColor,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      segment.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: isSelected 
                            ? Colors.white 
                            : effectiveUnselectedColor,
                      ),
                    ),
                  ),
                  if (segment.badgeCount != null && segment.badgeCount! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withOpacity(0.3) 
                            : AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        segment.badgeCount! > 99 
                            ? '99+' 
                            : segment.badgeCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? Colors.white 
                              : effectiveUnselectedColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Scrollable segmented control for many options
class ScrollableSegmentedControl<T> extends StatelessWidget {
  /// List of segments
  final List<Segment<T>> segments;
  
  /// Currently selected segment value
  final T selectedValue;
  
  /// Callback when segment is selected
  final ValueChanged<T>? onValueChanged;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Selected segment color
  final Color? selectedColor;
  
  /// Unselected text color
  final Color? unselectedColor;
  
  /// Border radius
  final double borderRadius;
  
  /// Padding around the control
  final EdgeInsetsGeometry? padding;

  const ScrollableSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedValue,
    this.onValueChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = 20.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;
    final effectiveUnselectedColor = unselectedColor ?? AppColors.secondary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          final isSelected = segment.value == selectedValue;
          final isLast = index == segments.length - 1;

          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: GestureDetector(
              onTap: onValueChanged != null 
                  ? () => onValueChanged!(segment.value) 
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? effectiveSelectedColor 
                      : backgroundColor ?? AppColors.border.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: isSelected 
                        ? effectiveSelectedColor 
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (segment.icon != null) ...[
                      Icon(
                        segment.icon,
                        size: 16,
                        color: isSelected 
                            ? Colors.white 
                            : effectiveUnselectedColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      segment.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: isSelected 
                            ? Colors.white 
                            : effectiveUnselectedColor,
                      ),
                    ),
                    if (segment.badgeCount != null && segment.badgeCount! > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.3) 
                              : AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          segment.badgeCount! > 99 
                              ? '99+' 
                              : segment.badgeCount.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white 
                                : effectiveUnselectedColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Quick segmented control presets
class QuickSegments {
  /// Invoice status segments
  static List<Segment<String>> invoiceStatuses() => [
        const Segment(value: 'all', label: 'All'),
        const Segment(value: 'paid', label: 'Paid', icon: Icons.check_circle),
        const Segment(value: 'unpaid', label: 'Unpaid', icon: Icons.pending),
      ];

  /// Time period segments
  static List<Segment<String>> timePeriods() => [
        const Segment(value: 'day', label: 'Day'),
        const Segment(value: 'week', label: 'Week'),
        const Segment(value: 'month', label: 'Month'),
        const Segment(value: 'year', label: 'Year'),
      ];

  /// View mode segments
  static List<Segment<String>> viewModes() => [
        const Segment(value: 'list', label: 'List', icon: Icons.list),
        const Segment(value: 'grid', label: 'Grid', icon: Icons.grid_view),
      ];
}
