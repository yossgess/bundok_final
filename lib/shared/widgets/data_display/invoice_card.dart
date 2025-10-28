import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../badges/status_badge.dart';
import '../chips/tag_chip.dart';

/// Compact invoice card for list views
/// 
/// Features:
/// - Displays vendor, date, amount, status badge, tags
/// - Pressable with shadow on tap
/// - RTL-safe layout (amount on left in RTL)
/// - Optional swipe actions
/// - Consistent styling and spacing
class InvoiceCard extends StatefulWidget {
  /// Invoice vendor/supplier name
  final String vendor;
  
  /// Invoice date
  final String date;
  
  /// Invoice amount
  final String amount;
  
  /// Invoice status
  final StatusType status;
  
  /// Optional status label override
  final String? statusLabel;
  
  /// Optional tags
  final List<String>? tags;
  
  /// Optional invoice number
  final String? invoiceNumber;
  
  /// Callback when card is pressed
  final VoidCallback? onTap;
  
  /// Optional callback when card is long pressed
  final VoidCallback? onLongPress;
  
  /// Optional leading widget (e.g., checkbox)
  final Widget? leading;
  
  /// Optional trailing widget
  final Widget? trailing;
  
  /// Whether to show shadow on press
  final bool showShadowOnPress;
  
  /// Card margin
  final EdgeInsetsGeometry? margin;
  
  /// Card padding
  final EdgeInsetsGeometry? padding;

  const InvoiceCard({
    super.key,
    required this.vendor,
    required this.date,
    required this.amount,
    required this.status,
    this.statusLabel,
    this.tags,
    this.invoiceNumber,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.showShadowOnPress = true,
    this.margin,
    this.padding,
  });

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return GestureDetector(
      onTapDown: widget.showShadowOnPress ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.showShadowOnPress ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.showShadowOnPress ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: widget.padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor and Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.vendor,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatusBadge(
                        label: widget.statusLabel ?? _getStatusLabel(widget.status),
                        type: widget.status,
                        size: StatusBadgeSize.small,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Invoice Number (if provided)
                  if (widget.invoiceNumber != null) ...[
                    Text(
                      'Invoice #${widget.invoiceNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.text.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  
                  // Date and Amount Row (RTL-safe)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isRTL) ...[
                        // LTR: Date on left, Amount on right
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text.withOpacity(0.7),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.amount,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ] else ...[
                        // RTL: Amount on left, Date on right
                        Text(
                          widget.amount,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  // Tags (if provided)
                  if (widget.tags != null && widget.tags!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.tags!.map((tag) {
                        return TagChip.small(
                          label: tag,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.trailing != null) ...[
              const SizedBox(width: 12),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(StatusType status) {
    switch (status) {
      case StatusType.paid:
        return 'Paid';
      case StatusType.unpaid:
        return 'Unpaid';
      case StatusType.draft:
        return 'Draft';
      case StatusType.pending:
        return 'Pending';
      case StatusType.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }
}

/// Compact invoice list item (alternative minimal design)
class InvoiceListItem extends StatelessWidget {
  /// Invoice vendor name
  final String vendor;
  
  /// Invoice amount
  final String amount;
  
  /// Invoice date
  final String date;
  
  /// Invoice status
  final StatusType status;
  
  /// Callback when item is pressed
  final VoidCallback? onTap;
  
  /// Optional leading icon
  final IconData? leadingIcon;

  const InvoiceListItem({
    super.key,
    required this.vendor,
    required this.amount,
    required this.date,
    required this.status,
    this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  leadingIcon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                StatusBadge(
                  label: _getStatusLabel(status),
                  type: status,
                  size: StatusBadgeSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(StatusType status) {
    switch (status) {
      case StatusType.paid:
        return 'Paid';
      case StatusType.unpaid:
        return 'Unpaid';
      case StatusType.draft:
        return 'Draft';
      case StatusType.pending:
        return 'Pending';
      case StatusType.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }
}

/// Swipeable invoice card with action buttons
class SwipeableInvoiceCard extends StatelessWidget {
  /// Invoice card widget
  final InvoiceCard card;
  
  /// Optional left swipe actions
  final List<SwipeAction>? leftActions;
  
  /// Optional right swipe actions
  final List<SwipeAction>? rightActions;

  const SwipeableInvoiceCard({
    super.key,
    required this.card,
    this.leftActions,
    this.rightActions,
  });

  @override
  Widget build(BuildContext context) {
    // Note: For full swipe functionality, consider using packages like:
    // - flutter_slidable
    // - swipe_to
    // This is a placeholder implementation
    return card;
  }
}

/// Swipe action configuration
class SwipeAction {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String? label;

  const SwipeAction({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.label,
  });
}
