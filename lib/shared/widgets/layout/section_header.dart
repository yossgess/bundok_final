import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Section header with title and optional action
/// 
/// Features:
/// - Title text with consistent styling
/// - Optional action button (e.g., "See All", "View More")
/// - Used in Dashboard ("Recent Invoices"), lists, etc.
/// - Optional subtitle for additional context
/// - Optional leading icon
/// - Consistent spacing and alignment
class SectionHeader extends StatelessWidget {
  /// Section title
  final String title;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Optional action label (e.g., "See All")
  final String? actionLabel;
  
  /// Optional action callback
  final VoidCallback? onActionPressed;
  
  /// Optional action icon
  final IconData? actionIcon;
  
  /// Optional leading icon
  final IconData? leadingIcon;
  
  /// Title text style
  final TextStyle? titleStyle;
  
  /// Subtitle text style
  final TextStyle? subtitleStyle;
  
  /// Action text style
  final TextStyle? actionStyle;
  
  /// Padding around the header
  final EdgeInsetsGeometry? padding;
  
  /// Spacing between title and action
  final double spacing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.actionIcon,
    this.leadingIcon,
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.padding,
    this.spacing = 8.0,
  });

  /// Section header with "See All" action
  const SectionHeader.withSeeAll({
    super.key,
    required this.title,
    this.subtitle,
    required this.onActionPressed,
    this.leadingIcon,
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.padding,
    this.spacing = 8.0,
  })  : actionLabel = 'See All',
        actionIcon = Icons.arrow_forward;

  /// Section header with custom action
  const SectionHeader.withAction({
    super.key,
    required this.title,
    this.subtitle,
    required this.actionLabel,
    required this.onActionPressed,
    this.actionIcon,
    this.leadingIcon,
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.padding,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle = titleStyle ??
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        );
    
    final effectiveSubtitleStyle = subtitleStyle ??
        TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.7),
        );
    
    final effectiveActionStyle = actionStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        );
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              size: 24,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: effectiveTitleStyle,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: spacing / 2),
                  Text(
                    subtitle!,
                    style: effectiveSubtitleStyle,
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(width: 16),
            InkWell(
              onTap: onActionPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel!,
                      style: effectiveActionStyle,
                    ),
                    if (actionIcon != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        actionIcon,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Collapsible section header with expand/collapse functionality
class CollapsibleSectionHeader extends StatelessWidget {
  /// Section title
  final String title;
  
  /// Whether section is expanded
  final bool isExpanded;
  
  /// Callback when expand/collapse is toggled
  final ValueChanged<bool>? onToggle;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Optional leading icon
  final IconData? leadingIcon;
  
  /// Title text style
  final TextStyle? titleStyle;
  
  /// Padding around the header
  final EdgeInsetsGeometry? padding;

  const CollapsibleSectionHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    this.onToggle,
    this.subtitle,
    this.leadingIcon,
    this.titleStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle = titleStyle ??
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        );
    
    return InkWell(
      onTap: onToggle != null ? () => onToggle!(!isExpanded) : null,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 24,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: effectiveTitleStyle,
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
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tabbed section header with tab selection
class TabbedSectionHeader extends StatelessWidget {
  /// Section title
  final String title;
  
  /// Tab labels
  final List<String> tabs;
  
  /// Currently selected tab index
  final int selectedIndex;
  
  /// Callback when tab is selected
  final ValueChanged<int>? onTabSelected;
  
  /// Optional action label
  final String? actionLabel;
  
  /// Optional action callback
  final VoidCallback? onActionPressed;
  
  /// Padding around the header
  final EdgeInsetsGeometry? padding;

  const TabbedSectionHeader({
    super.key,
    required this.title,
    required this.tabs,
    required this.selectedIndex,
    this.onTabSelected,
    this.actionLabel,
    this.onActionPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              if (actionLabel != null && onActionPressed != null)
                InkWell(
                  onTap: onActionPressed,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = index == selectedIndex;
                return Padding(
                  padding: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
                  child: InkWell(
                    onTap: onTabSelected != null ? () => onTabSelected!(index) : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple divider header for grouping content
class DividerHeader extends StatelessWidget {
  /// Header label
  final String label;
  
  /// Label text style
  final TextStyle? labelStyle;
  
  /// Divider color
  final Color? dividerColor;
  
  /// Padding around the header
  final EdgeInsetsGeometry? padding;

  const DividerHeader({
    super.key,
    required this.label,
    this.labelStyle,
    this.dividerColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.text.withOpacity(0.6),
          letterSpacing: 0.5,
        );
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: effectiveLabelStyle,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: dividerColor ?? AppColors.border,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
