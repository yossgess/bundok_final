import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Custom bottom navigation bar item
/// 
/// Features:
/// - Custom tab bar item (for centered FAB workaround)
/// - Icon + label with active state
/// - Optional badge support
/// - Smooth animations
/// - Customizable colors
class BottomNavigationItem extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Label text
  final String label;
  
  /// Whether item is selected/active
  final bool isSelected;
  
  /// Callback when item is tapped
  final VoidCallback? onTap;
  
  /// Optional badge count
  final int? badgeCount;
  
  /// Active color
  final Color? activeColor;
  
  /// Inactive color
  final Color? inactiveColor;
  
  /// Whether to show label
  final bool showLabel;
  
  /// Icon size
  final double iconSize;

  const BottomNavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.badgeCount,
    this.activeColor,
    this.inactiveColor,
    this.showLabel = true,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ?? 
        AppColors.text.withOpacity(0.6);
    
    final color = isSelected ? effectiveActiveColor : effectiveInactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? effectiveActiveColor.withOpacity(0.1) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  ),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badgeCount! > 9 ? '9+' : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom bottom navigation bar with centered FAB support
class ThemedBottomNavigationBar extends StatelessWidget {
  /// List of navigation items
  final List<BottomNavItem> items;
  
  /// Currently selected index
  final int selectedIndex;
  
  /// Callback when item is selected
  final ValueChanged<int>? onItemSelected;
  
  /// Whether to show a gap for centered FAB
  final bool hasCenterGap;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Active item color
  final Color? activeColor;
  
  /// Inactive item color
  final Color? inactiveColor;
  
  /// Whether to show labels
  final bool showLabels;
  
  /// Elevation
  final double elevation;

  const ThemedBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.hasCenterGap = false,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
    this.elevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.background;
    
    // Split items if there's a center gap
    final leftItems = hasCenterGap && items.length > 2
        ? items.sublist(0, items.length ~/ 2)
        : items;
    
    final rightItems = hasCenterGap && items.length > 2
        ? items.sublist(items.length ~/ 2)
        : <BottomNavItem>[];

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1),
            blurRadius: elevation,
            offset: Offset(0, -elevation / 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left items
              ...leftItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Expanded(
                  child: BottomNavigationItem(
                    icon: item.icon,
                    label: item.label,
                    isSelected: selectedIndex == index,
                    badgeCount: item.badgeCount,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    showLabel: showLabels,
                    onTap: onItemSelected != null 
                        ? () => onItemSelected!(index) 
                        : null,
                  ),
                );
              }),
              
              // Center gap for FAB
              if (hasCenterGap)
                const SizedBox(width: 80),
              
              // Right items
              ...rightItems.asMap().entries.map((entry) {
                final index = entry.key + leftItems.length;
                final item = entry.value;
                return Expanded(
                  child: BottomNavigationItem(
                    icon: item.icon,
                    label: item.label,
                    isSelected: selectedIndex == index,
                    badgeCount: item.badgeCount,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    showLabel: showLabels,
                    onTap: onItemSelected != null 
                        ? () => onItemSelected!(index) 
                        : null,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation item data model
class BottomNavItem {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const BottomNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}

/// Compact bottom navigation bar (icons only)
class CompactBottomNavigationBar extends StatelessWidget {
  /// List of navigation items
  final List<BottomNavItem> items;
  
  /// Currently selected index
  final int selectedIndex;
  
  /// Callback when item is selected
  final ValueChanged<int>? onItemSelected;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Active item color
  final Color? activeColor;
  
  /// Inactive item color
  final Color? inactiveColor;

  const CompactBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedBottomNavigationBar(
      items: items,
      selectedIndex: selectedIndex,
      onItemSelected: onItemSelected,
      backgroundColor: backgroundColor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      showLabels: false,
      elevation: 0,
    );
  }
}

/// Floating bottom navigation bar
class FloatingBottomNavigationBar extends StatelessWidget {
  /// List of navigation items
  final List<BottomNavItem> items;
  
  /// Currently selected index
  final int selectedIndex;
  
  /// Callback when item is selected
  final ValueChanged<int>? onItemSelected;
  
  /// Whether to show a gap for centered FAB
  final bool hasCenterGap;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Active item color
  final Color? activeColor;
  
  /// Inactive item color
  final Color? inactiveColor;
  
  /// Margin around the bar
  final EdgeInsetsGeometry? margin;

  const FloatingBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.hasCenterGap = false,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.background,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ThemedBottomNavigationBar(
          items: items,
          selectedIndex: selectedIndex,
          onItemSelected: onItemSelected,
          hasCenterGap: hasCenterGap,
          backgroundColor: Colors.transparent,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          elevation: 0,
        ),
      ),
    );
  }
}

/// Bottom navigation bar with indicator
class IndicatorBottomNavigationBar extends StatelessWidget {
  /// List of navigation items
  final List<BottomNavItem> items;
  
  /// Currently selected index
  final int selectedIndex;
  
  /// Callback when item is selected
  final ValueChanged<int>? onItemSelected;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Active item color
  final Color? activeColor;
  
  /// Indicator color
  final Color? indicatorColor;

  const IndicatorBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.backgroundColor,
    this.activeColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIndicatorColor = indicatorColor ?? 
        activeColor ?? 
        AppColors.primary;

    return Container(
      color: backgroundColor ?? AppColors.background,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              margin: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width / items.length) * 
                    selectedIndex,
                right: (MediaQuery.of(context).size.width / items.length) * 
                    (items.length - selectedIndex - 1),
              ),
              decoration: BoxDecoration(
                color: effectiveIndicatorColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(3),
                ),
              ),
            ),
            
            // Navigation items
            ThemedBottomNavigationBar(
              items: items,
              selectedIndex: selectedIndex,
              onItemSelected: onItemSelected,
              backgroundColor: Colors.transparent,
              activeColor: activeColor,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }
}
