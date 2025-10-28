import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Tag chip component for displaying labels and categories
/// 
/// Features:
/// - Rounded rectangle with bg AppColors.accent (#B8A9FF), text AppColors.secondary
/// - Optional close icon for removable tags
/// - Pressable with onPressed callback
/// - Consistent height (24-32dp)
/// - Optional leading icon
/// - Compact and visually distinct
class TagChip extends StatelessWidget {
  /// Tag label text
  final String label;
  
  /// Optional callback when chip is pressed
  final VoidCallback? onPressed;
  
  /// Optional callback when close icon is pressed
  final VoidCallback? onDeleted;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Optional custom background color
  final Color? backgroundColor;
  
  /// Optional custom text color
  final Color? textColor;
  
  /// Optional custom border color
  final Color? borderColor;
  
  /// Chip size variant
  final TagChipSize size;
  
  /// Whether chip is selected
  final bool selected;
  
  /// Optional avatar widget (displayed before label)
  final Widget? avatar;

  const TagChip({
    super.key,
    required this.label,
    this.onPressed,
    this.onDeleted,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.size = TagChipSize.medium,
    this.selected = false,
    this.avatar,
  });

  /// Small tag chip (height: 24dp)
  const TagChip.small({
    super.key,
    required this.label,
    this.onPressed,
    this.onDeleted,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.selected = false,
    this.avatar,
  }) : size = TagChipSize.small;

  /// Large tag chip (height: 36dp)
  const TagChip.large({
    super.key,
    required this.label,
    this.onPressed,
    this.onDeleted,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.selected = false,
    this.avatar,
  }) : size = TagChipSize.large;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        (selected ? AppColors.accent : AppColors.accent.withOpacity(0.15));
    final effectiveTextColor = textColor ?? AppColors.secondary;
    final effectiveBorderColor = borderColor ?? AppColors.accent;
    
    final chipHeight = size.height;
    final chipFontSize = size.fontSize;
    final chipIconSize = size.iconSize;
    final chipPadding = size.padding;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(chipHeight / 2),
        child: Container(
          height: chipHeight,
          padding: chipPadding,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(chipHeight / 2),
            border: Border.all(
              color: effectiveBorderColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: 4),
              ] else if (icon != null) ...[
                Icon(
                  icon,
                  size: chipIconSize,
                  color: effectiveTextColor,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: chipFontSize,
                  fontWeight: FontWeight.w500,
                  color: effectiveTextColor,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: onDeleted,
                  borderRadius: BorderRadius.circular(chipIconSize),
                  child: Icon(
                    Icons.close,
                    size: chipIconSize,
                    color: effectiveTextColor.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Tag chip size variants
enum TagChipSize {
  small(24.0, 11.0, 14.0, EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
  medium(28.0, 12.0, 16.0, EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
  large(36.0, 14.0, 18.0, EdgeInsets.symmetric(horizontal: 16, vertical: 8));

  const TagChipSize(this.height, this.fontSize, this.iconSize, this.padding);
  
  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
}

/// Filter chip variant for selection/filtering
class FilterChip extends StatelessWidget {
  /// Chip label
  final String label;
  
  /// Whether chip is selected
  final bool selected;
  
  /// Callback when selection changes
  final ValueChanged<bool>? onSelected;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Chip size
  final TagChipSize size;

  const FilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.size = TagChipSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return TagChip(
      label: label,
      icon: icon,
      selected: selected,
      size: size,
      onPressed: onSelected != null ? () => onSelected!(!selected) : null,
      backgroundColor: selected 
          ? AppColors.accent 
          : AppColors.accent.withOpacity(0.1),
    );
  }
}

/// Choice chip for single selection from a group
class ChoiceChip extends StatelessWidget {
  /// Chip label
  final String label;
  
  /// Whether chip is selected
  final bool selected;
  
  /// Callback when chip is selected
  final VoidCallback? onSelected;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Chip size
  final TagChipSize size;

  const ChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.size = TagChipSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return TagChip(
      label: label,
      icon: icon,
      selected: selected,
      size: size,
      onPressed: onSelected,
      backgroundColor: selected 
          ? AppColors.primary 
          : AppColors.border,
      textColor: selected 
          ? Colors.white 
          : AppColors.secondary,
      borderColor: selected 
          ? AppColors.primary 
          : AppColors.border,
    );
  }
}
