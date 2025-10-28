import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Status badge variants for semantic states
enum StatusType {
  /// Paid status (green)
  paid,
  
  /// Unpaid status (orange)
  unpaid,
  
  /// Draft status (gray)
  draft,
  
  /// Pending status (blue)
  pending,
  
  /// Cancelled status (red)
  cancelled,
  
  /// Success status (green)
  success,
  
  /// Warning status (orange)
  warning,
  
  /// Error status (red)
  error,
  
  /// Info status (blue)
  info,
}

/// Status badge component for displaying semantic states
/// 
/// Features:
/// - Semantic variants: paid (green), unpaid (orange), draft (gray)
/// - Consistent padding and typography
/// - Optional icon support
/// - Compact and visually distinct
/// - Rounded corners for modern look
class StatusBadge extends StatelessWidget {
  /// Badge label text
  final String label;
  
  /// Status type determining color scheme
  final StatusType type;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Badge size variant
  final StatusBadgeSize size;
  
  /// Whether to use outlined style
  final bool outlined;
  
  /// Optional custom colors (overrides type colors)
  final Color? customBackgroundColor;
  final Color? customTextColor;
  final Color? customBorderColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.icon,
    this.size = StatusBadgeSize.medium,
    this.outlined = false,
    this.customBackgroundColor,
    this.customTextColor,
    this.customBorderColor,
  });

  /// Paid status badge (green)
  const StatusBadge.paid({
    super.key,
    this.label = 'Paid',
    this.icon,
    this.size = StatusBadgeSize.medium,
    this.outlined = false,
  })  : type = StatusType.paid,
        customBackgroundColor = null,
        customTextColor = null,
        customBorderColor = null;

  /// Unpaid status badge (orange)
  const StatusBadge.unpaid({
    super.key,
    this.label = 'Unpaid',
    this.icon,
    this.size = StatusBadgeSize.medium,
    this.outlined = false,
  })  : type = StatusType.unpaid,
        customBackgroundColor = null,
        customTextColor = null,
        customBorderColor = null;

  /// Draft status badge (gray)
  const StatusBadge.draft({
    super.key,
    this.label = 'Draft',
    this.icon,
    this.size = StatusBadgeSize.medium,
    this.outlined = false,
  })  : type = StatusType.draft,
        customBackgroundColor = null,
        customTextColor = null,
        customBorderColor = null;

  /// Pending status badge (blue)
  const StatusBadge.pending({
    super.key,
    this.label = 'Pending',
    this.icon,
    this.size = StatusBadgeSize.medium,
    this.outlined = false,
  })  : type = StatusType.pending,
        customBackgroundColor = null,
        customTextColor = null,
        customBorderColor = null;

  /// Cancelled status badge (red)
  const StatusBadge.cancelled({
    super.key,
    this.label = 'Cancelled',
    this.icon,
    this.size = StatusBadgeSize.medium,
    this.outlined = false,
  })  : type = StatusType.cancelled,
        customBackgroundColor = null,
        customTextColor = null,
        customBorderColor = null;

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsForType(type);
    final backgroundColor = customBackgroundColor ?? 
        (outlined ? Colors.transparent : colors.background);
    final textColor = customTextColor ?? 
        (outlined ? colors.foreground : colors.foreground);
    final borderColor = customBorderColor ?? colors.foreground;
    
    final badgeHeight = size.height;
    final badgeFontSize = size.fontSize;
    final badgeIconSize = size.iconSize;
    final badgePadding = size.padding;
    
    return Container(
      height: badgeHeight,
      padding: badgePadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(badgeHeight / 2),
        border: outlined 
            ? Border.all(color: borderColor, width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: badgeIconSize,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: badgeFontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Get color scheme for status type
  _StatusColors _getColorsForType(StatusType type) {
    switch (type) {
      case StatusType.paid:
      case StatusType.success:
        return _StatusColors(
          background: AppColors.success.withOpacity(0.15),
          foreground: AppColors.success,
        );
      
      case StatusType.unpaid:
      case StatusType.warning:
        return _StatusColors(
          background: AppColors.warning.withOpacity(0.15),
          foreground: AppColors.warning,
        );
      
      case StatusType.draft:
        return _StatusColors(
          background: AppColors.secondary.withOpacity(0.1),
          foreground: AppColors.secondary.withOpacity(0.7),
        );
      
      case StatusType.pending:
      case StatusType.info:
        return _StatusColors(
          background: AppColors.primary.withOpacity(0.15),
          foreground: AppColors.primary,
        );
      
      case StatusType.cancelled:
      case StatusType.error:
        return _StatusColors(
          background: AppColors.error.withOpacity(0.15),
          foreground: AppColors.error,
        );
    }
  }
}

/// Status badge size variants
enum StatusBadgeSize {
  small(20.0, 10.0, 12.0, EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
  medium(24.0, 11.0, 14.0, EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
  large(28.0, 12.0, 16.0, EdgeInsets.symmetric(horizontal: 12, vertical: 6));

  const StatusBadgeSize(this.height, this.fontSize, this.iconSize, this.padding);
  
  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
}

/// Internal color scheme for status badges
class _StatusColors {
  final Color background;
  final Color foreground;

  const _StatusColors({
    required this.background,
    required this.foreground,
  });
}

/// Notification badge (typically shows count)
class NotificationBadge extends StatelessWidget {
  /// Badge count
  final int count;
  
  /// Maximum count to display (shows "99+" if exceeded)
  final int maxCount;
  
  /// Badge size
  final double size;
  
  /// Optional custom background color
  final Color? backgroundColor;
  
  /// Optional custom text color
  final Color? textColor;

  const NotificationBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.size = 18,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    
    final displayText = count > maxCount ? '$maxCount+' : count.toString();
    final effectiveBackgroundColor = backgroundColor ?? AppColors.error;
    final effectiveTextColor = textColor ?? Colors.white;
    
    return Container(
      height: size,
      constraints: BoxConstraints(minWidth: size),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            color: effectiveTextColor,
            height: 1,
          ),
        ),
      ),
    );
  }
}
