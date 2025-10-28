import 'package:flutter/material.dart' hide FloatingActionButton;
import 'package:flutter/material.dart' as material show FloatingActionButton;
import '../../../core/constants/app_colors.dart';

/// Themed floating action button
/// 
/// Features:
/// - Circular with AppColors.primary
/// - Icon only (e.g., camera), elevated
/// - Optional extended variant with label
/// - Mini and large size variants
/// - Customizable colors and elevation
class ThemedFAB extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Optional tooltip
  final String? tooltip;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Foreground color (icon color)
  final Color? foregroundColor;
  
  /// Elevation
  final double elevation;
  
  /// Highlight elevation (when pressed)
  final double highlightElevation;
  
  /// FAB size variant
  final FABSize size;
  
  /// Optional hero tag
  final Object? heroTag;

  const ThemedFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.size = FABSize.regular,
    this.heroTag,
  });

  /// Mini FAB variant
  const ThemedFAB.mini({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.heroTag,
  }) : size = FABSize.mini;

  /// Large FAB variant
  const ThemedFAB.large({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.heroTag,
  }) : size = FABSize.large;

  /// Camera FAB (common use case)
  const ThemedFAB.camera({
    super.key,
    required this.onPressed,
    this.tooltip = 'Scan Invoice',
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.size = FABSize.regular,
    this.heroTag,
  }) : icon = Icons.camera_alt;

  /// Add FAB (common use case)
  const ThemedFAB.add({
    super.key,
    required this.onPressed,
    this.tooltip = 'Add',
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.size = FABSize.regular,
    this.heroTag,
  }) : icon = Icons.add;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;

    Widget fab;
    
    switch (size) {
      case FABSize.mini:
        fab = material.FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: elevation,
          highlightElevation: highlightElevation,
          tooltip: tooltip,
          heroTag: heroTag,
          child: Icon(icon, size: 20),
        );
        break;
      
      case FABSize.large:
        fab = material.FloatingActionButton.large(
          onPressed: onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: elevation,
          highlightElevation: highlightElevation,
          tooltip: tooltip,
          heroTag: heroTag,
          child: Icon(icon, size: 32),
        );
        break;
      
      case FABSize.regular:
        fab = material.FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: elevation,
          highlightElevation: highlightElevation,
          tooltip: tooltip,
          heroTag: heroTag,
          child: Icon(icon, size: 24),
        );
    }

    return fab;
  }
}

/// FAB size variants
enum FABSize {
  mini,
  regular,
  large,
}

/// Extended FAB with label
class ExtendedThemedFAB extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Label text
  final String label;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Optional tooltip
  final String? tooltip;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Foreground color
  final Color? foregroundColor;
  
  /// Elevation
  final double elevation;
  
  /// Highlight elevation
  final double highlightElevation;
  
  /// Optional hero tag
  final Object? heroTag;

  const ExtendedThemedFAB({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.heroTag,
  });

  /// Scan invoice extended FAB
  const ExtendedThemedFAB.scan({
    super.key,
    required this.onPressed,
    this.tooltip = 'Scan Invoice',
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.heroTag,
  })  : icon = Icons.camera_alt,
        label = 'Scan Invoice';

  /// Add invoice extended FAB
  const ExtendedThemedFAB.add({
    super.key,
    required this.onPressed,
    this.tooltip = 'Add Invoice',
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.heroTag,
  })  : icon = Icons.add,
        label = 'Add Invoice';

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;

    return material.FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      highlightElevation: highlightElevation,
      tooltip: tooltip,
      heroTag: heroTag,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Animated FAB that can expand/collapse
class AnimatedThemedFAB extends StatefulWidget {
  /// Icon to display
  final IconData icon;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Whether FAB is expanded
  final bool isExtended;
  
  /// Label text (shown when extended)
  final String? label;
  
  /// Optional tooltip
  final String? tooltip;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Foreground color
  final Color? foregroundColor;

  const AnimatedThemedFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isExtended,
    this.label,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AnimatedThemedFAB> createState() => _AnimatedThemedFABState();
}

class _AnimatedThemedFABState extends State<AnimatedThemedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    if (widget.isExtended) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedThemedFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExtended != oldWidget.isExtended) {
      if (widget.isExtended) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = widget.backgroundColor ?? AppColors.primary;
    final effectiveForegroundColor = widget.foregroundColor ?? Colors.white;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return material.FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          tooltip: widget.tooltip,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 24),
              if (widget.label != null)
                SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: Text(
                      widget.label!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// FAB with multiple actions (speed dial)
class SpeedDialFAB extends StatefulWidget {
  /// Main FAB icon
  final IconData icon;
  
  /// List of speed dial actions
  final List<SpeedDialAction> actions;
  
  /// Optional tooltip
  final String? tooltip;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Foreground color
  final Color? foregroundColor;

  const SpeedDialFAB({
    super.key,
    required this.icon,
    required this.actions,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleActionTap(VoidCallback? onTap) {
    _toggle();
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = widget.backgroundColor ?? AppColors.primary;
    final effectiveForegroundColor = widget.foregroundColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Speed dial actions
        ...widget.actions.reversed.map((action) {
          return ScaleTransition(
            scale: _controller,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (action.label != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        action.label!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  material.FloatingActionButton.small(
                    onPressed: () => _handleActionTap(action.onTap),
                    backgroundColor: action.backgroundColor ?? 
                        AppColors.background,
                    foregroundColor: action.foregroundColor ?? 
                        AppColors.secondary,
                    heroTag: action.heroTag,
                    child: Icon(action.icon, size: 20),
                  ),
                ],
              ),
            ),
          );
        }),
        
        // Main FAB
        material.FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          tooltip: widget.tooltip,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _isOpen ? Icons.close : widget.icon,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

/// Speed dial action data model
class SpeedDialAction {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Object? heroTag;

  const SpeedDialAction({
    required this.icon,
    this.label,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  });
}
