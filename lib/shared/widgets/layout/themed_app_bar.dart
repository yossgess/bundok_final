import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Themed app bar with consistent styling
/// 
/// Features:
/// - Title (centered or leading)
/// - Optional actions (search, settings, etc.)
/// - Background: AppColors.background
/// - Icon/text color: AppColors.secondary
/// - Optional leading widget (back button, menu, etc.)
/// - Elevation control
/// - RTL support
class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String? title;
  
  /// Custom title widget (overrides title string)
  final Widget? titleWidget;
  
  /// Whether to center the title
  final bool centerTitle;
  
  /// Optional leading widget (back button, menu icon, etc.)
  final Widget? leading;
  
  /// Whether to automatically add back button
  final bool automaticallyImplyLeading;
  
  /// Action buttons (right side for LTR, left side for RTL)
  final List<Widget>? actions;
  
  /// Optional bottom widget (e.g., TabBar, search field)
  final PreferredSizeWidget? bottom;
  
  /// App bar elevation
  final double elevation;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// Optional foreground color override
  final Color? foregroundColor;
  
  /// Title text style
  final TextStyle? titleTextStyle;
  
  /// App bar height
  final double toolbarHeight;

  const ThemedAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.titleTextStyle,
    this.toolbarHeight = kToolbarHeight,
  });

  /// App bar with centered title
  const ThemedAppBar.centered({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.titleTextStyle,
    this.toolbarHeight = kToolbarHeight,
  }) : centerTitle = true;

  /// App bar with leading title
  const ThemedAppBar.leading({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.titleTextStyle,
    this.toolbarHeight = kToolbarHeight,
  }) : centerTitle = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.background;
    final effectiveForegroundColor = foregroundColor ?? AppColors.secondary;
    
    Widget? effectiveTitle;
    if (titleWidget != null) {
      effectiveTitle = titleWidget;
    } else if (title != null) {
      effectiveTitle = Text(
        title!,
        style: titleTextStyle ?? TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: effectiveForegroundColor,
        ),
      );
    }
    
    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      title: effectiveTitle,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      iconTheme: IconThemeData(
        color: effectiveForegroundColor,
        size: 24,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

/// App bar with search field
class ThemedSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Search query controller
  final TextEditingController? controller;
  
  /// Search hint text
  final String hintText;
  
  /// Callback when search query changes
  final ValueChanged<String>? onChanged;
  
  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Optional leading widget
  final Widget? leading;
  
  /// Optional actions
  final List<Widget>? actions;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// App bar height
  final double toolbarHeight;

  const ThemedSearchAppBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.actions,
    this.showClearButton = true,
    this.backgroundColor,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.background;
    
    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      elevation: 0,
      toolbarHeight: toolbarHeight,
      leading: leading,
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.text,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: AppColors.text.withOpacity(0.5),
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.secondary,
            size: 20,
          ),
          suffixIcon: showClearButton && 
                      controller != null && 
                      controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  onPressed: () {
                    controller?.clear();
                    onChanged?.call('');
                  },
                )
              : null,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

/// Sliver app bar variant for scrollable pages
class ThemedSliverAppBar extends StatelessWidget {
  /// App bar title
  final String? title;
  
  /// Custom title widget
  final Widget? titleWidget;
  
  /// Whether to center the title
  final bool centerTitle;
  
  /// Optional leading widget
  final Widget? leading;
  
  /// Action buttons
  final List<Widget>? actions;
  
  /// Whether app bar floats
  final bool floating;
  
  /// Whether app bar is pinned
  final bool pinned;
  
  /// Whether app bar snaps
  final bool snap;
  
  /// Expanded height when fully expanded
  final double? expandedHeight;
  
  /// Flexible space widget (shown when expanded)
  final Widget? flexibleSpace;
  
  /// Optional background color override
  final Color? backgroundColor;
  
  /// Optional foreground color override
  final Color? foregroundColor;
  
  /// Collapsed height
  final double collapsedHeight;

  const ThemedSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.backgroundColor,
    this.foregroundColor,
    this.collapsedHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.background;
    final effectiveForegroundColor = foregroundColor ?? AppColors.secondary;
    
    Widget? effectiveTitle;
    if (titleWidget != null) {
      effectiveTitle = titleWidget;
    } else if (title != null) {
      effectiveTitle = Text(
        title!,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: effectiveForegroundColor,
        ),
      );
    }
    
    return SliverAppBar(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      title: effectiveTitle,
      leading: leading,
      actions: actions,
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      collapsedHeight: collapsedHeight,
      iconTheme: IconThemeData(
        color: effectiveForegroundColor,
        size: 24,
      ),
    );
  }
}

/// App bar action button helper
class AppBarAction extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Callback when pressed
  final VoidCallback? onPressed;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Optional badge count
  final int? badgeCount;
  
  /// Icon color
  final Color? color;

  const AppBarAction({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.badgeCount,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconButton = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color ?? AppColors.secondary,
    );
    
    // Add badge if count is provided
    if (badgeCount != null && badgeCount! > 0) {
      return Stack(
        children: [
          iconButton,
          Positioned(
            right: 8,
            top: 8,
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
                badgeCount! > 99 ? '99+' : badgeCount.toString(),
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
      );
    }
    
    return iconButton;
  }
}
