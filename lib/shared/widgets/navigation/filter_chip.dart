import 'package:flutter/material.dart' hide FilterChip;
import '../../../core/constants/app_colors.dart';

/// Toggleable filter chip component
/// 
/// Features:
/// - Toggleable chip for filters (e.g., "This Week", "Utilities")
/// - Active: filled with AppColors.primary, white text
/// - Inactive: outlined with border
/// - Optional icon support
/// - Consistent styling
class FilterChip extends StatelessWidget {
  /// Chip label
  final String label;
  
  /// Whether chip is selected/active
  final bool selected;
  
  /// Callback when selection changes
  final ValueChanged<bool>? onSelected;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Optional badge count
  final int? badgeCount;
  
  /// Chip size variant
  final FilterChipSize size;
  
  /// Whether chip is enabled
  final bool enabled;
  
  /// Optional custom active color
  final Color? activeColor;
  
  /// Optional custom inactive color
  final Color? inactiveColor;
  
  /// Padding around the chip
  final EdgeInsetsGeometry? padding;

  const FilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.badgeCount,
    this.size = FilterChipSize.medium,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.padding,
  });

  /// Small filter chip
  const FilterChip.small({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.badgeCount,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.padding,
  }) : size = FilterChipSize.small;

  /// Large filter chip
  const FilterChip.large({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.badgeCount,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.padding,
  }) : size = FilterChipSize.large;

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ?? Colors.transparent;
    
    final backgroundColor = selected 
        ? effectiveActiveColor 
        : effectiveInactiveColor;
    
    final textColor = selected 
        ? Colors.white 
        : AppColors.secondary;
    
    final borderColor = selected 
        ? effectiveActiveColor 
        : AppColors.border;

    return InkWell(
      onTap: enabled && onSelected != null 
          ? () => onSelected!(!selected) 
          : null,
      borderRadius: BorderRadius.circular(size.height / 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size.height,
        padding: padding ?? size.padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size.height / 2),
          border: Border.all(
            color: borderColor,
            width: selected ? 0 : 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: size.iconSize,
                color: textColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: size.fontSize,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
              ),
            ),
            if (badgeCount != null && badgeCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected 
                      ? Colors.white.withOpacity(0.3) 
                      : AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeCount! > 99 ? '99+' : badgeCount.toString(),
                  style: TextStyle(
                    fontSize: size.fontSize - 2,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Filter chip size variants
enum FilterChipSize {
  small(28.0, 12.0, 16.0, EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
  medium(36.0, 14.0, 18.0, EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
  large(44.0, 16.0, 20.0, EdgeInsets.symmetric(horizontal: 20, vertical: 10));

  const FilterChipSize(this.height, this.fontSize, this.iconSize, this.padding);
  
  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
}

/// Filter chip group for multiple selections
class FilterChipGroup extends StatelessWidget {
  /// List of filter options
  final List<FilterOption> options;
  
  /// Currently selected filter IDs
  final List<String> selectedIds;
  
  /// Callback when selection changes
  final ValueChanged<List<String>>? onSelectionChanged;
  
  /// Whether to allow multiple selection
  final bool multiSelect;
  
  /// Chip size
  final FilterChipSize size;
  
  /// Spacing between chips
  final double spacing;
  
  /// Run spacing (vertical spacing)
  final double runSpacing;
  
  /// Padding around the group
  final EdgeInsetsGeometry? padding;

  const FilterChipGroup({
    super.key,
    required this.options,
    required this.selectedIds,
    this.onSelectionChanged,
    this.multiSelect = true,
    this.size = FilterChipSize.medium,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.padding,
  });

  void _handleSelection(String id) {
    if (onSelectionChanged == null) return;
    
    List<String> newSelection;
    
    if (multiSelect) {
      if (selectedIds.contains(id)) {
        newSelection = selectedIds.where((selectedId) => selectedId != id).toList();
      } else {
        newSelection = [...selectedIds, id];
      }
    } else {
      newSelection = selectedIds.contains(id) ? [] : [id];
    }
    
    onSelectionChanged!(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: options.map((option) {
          final isSelected = selectedIds.contains(option.id);
          return FilterChip(
            label: option.label,
            selected: isSelected,
            icon: option.icon,
            badgeCount: option.count,
            size: size,
            onSelected: (_) => _handleSelection(option.id),
          );
        }).toList(),
      ),
    );
  }
}

/// Filter option data model
class FilterOption {
  final String id;
  final String label;
  final IconData? icon;
  final int? count;

  const FilterOption({
    required this.id,
    required this.label,
    this.icon,
    this.count,
  });
}

/// Horizontal scrollable filter bar
class FilterBar extends StatelessWidget {
  /// List of filter options
  final List<FilterOption> options;
  
  /// Currently selected filter ID
  final String? selectedId;
  
  /// Callback when filter is selected
  final ValueChanged<String>? onFilterSelected;
  
  /// Chip size
  final FilterChipSize size;
  
  /// Padding around the bar
  final EdgeInsetsGeometry? padding;
  
  /// Background color
  final Color? backgroundColor;

  const FilterBar({
    super.key,
    required this.options,
    this.selectedId,
    this.onFilterSelected,
    this.size = FilterChipSize.medium,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedId == option.id;
            final isLast = index == options.length - 1;
            
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 8),
              child: FilterChip(
                label: option.label,
                selected: isSelected,
                icon: option.icon,
                badgeCount: option.count,
                size: size,
                onSelected: (_) => onFilterSelected?.call(option.id),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Quick filter presets for common use cases
class QuickFilters {
  /// Time period filters
  static List<FilterOption> timePeriods() => [
        const FilterOption(id: 'today', label: 'Today'),
        const FilterOption(id: 'week', label: 'This Week'),
        const FilterOption(id: 'month', label: 'This Month'),
        const FilterOption(id: 'year', label: 'This Year'),
        const FilterOption(id: 'all', label: 'All Time'),
      ];

  /// Invoice status filters
  static List<FilterOption> invoiceStatuses() => [
        const FilterOption(id: 'all', label: 'All'),
        const FilterOption(id: 'paid', label: 'Paid', icon: Icons.check_circle),
        const FilterOption(id: 'unpaid', label: 'Unpaid', icon: Icons.pending),
        const FilterOption(id: 'draft', label: 'Draft', icon: Icons.edit),
      ];

  /// Category filters (example)
  static List<FilterOption> categories() => [
        const FilterOption(id: 'utilities', label: 'Utilities', icon: Icons.bolt),
        const FilterOption(id: 'office', label: 'Office', icon: Icons.business),
        const FilterOption(id: 'travel', label: 'Travel', icon: Icons.flight),
        const FilterOption(id: 'equipment', label: 'Equipment', icon: Icons.devices),
      ];
}

/// Filter dropdown button
class FilterDropdown extends StatelessWidget {
  /// Current filter label
  final String label;
  
  /// Callback when dropdown is pressed
  final VoidCallback? onPressed;
  
  /// Optional badge count
  final int? activeFiltersCount;
  
  /// Whether dropdown is enabled
  final bool enabled;

  const FilterDropdown({
    super.key,
    required this.label,
    this.onPressed,
    this.activeFiltersCount,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: activeFiltersCount != null && activeFiltersCount! > 0
                ? AppColors.primary
                : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 18,
              color: activeFiltersCount != null && activeFiltersCount! > 0
                  ? AppColors.primary
                  : AppColors.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: activeFiltersCount != null && activeFiltersCount! > 0
                    ? AppColors.primary
                    : AppColors.secondary,
              ),
            ),
            if (activeFiltersCount != null && activeFiltersCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  activeFiltersCount.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
