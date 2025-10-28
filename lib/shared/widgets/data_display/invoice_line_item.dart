import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Invoice line item row component
/// 
/// Features:
/// - Displays: description, quantity, unit price, total
/// - Used in invoice detail screen
/// - RTL-safe layout
/// - Optional editing capabilities
/// - Consistent spacing and alignment
class InvoiceLineItem extends StatelessWidget {
  /// Item description
  final String description;
  
  /// Item quantity
  final String quantity;
  
  /// Unit price
  final String unitPrice;
  
  /// Total amount
  final String total;
  
  /// Optional item number/index
  final int? itemNumber;
  
  /// Whether to show header row
  final bool isHeader;
  
  /// Optional callback when item is tapped
  final VoidCallback? onTap;
  
  /// Optional callback when item is deleted
  final VoidCallback? onDelete;
  
  /// Padding around the item
  final EdgeInsetsGeometry? padding;
  
  /// Whether to show divider below
  final bool showDivider;

  const InvoiceLineItem({
    super.key,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.itemNumber,
    this.isHeader = false,
    this.onTap,
    this.onDelete,
    this.padding,
    this.showDivider = true,
  });

  /// Header row for line items table
  const InvoiceLineItem.header({
    super.key,
    this.padding,
    this.showDivider = true,
  })  : description = 'Description',
        quantity = 'Qty',
        unitPrice = 'Price',
        total = 'Total',
        itemNumber = null,
        isHeader = true,
        onTap = null,
        onDelete = null;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final textStyle = isHeader
        ? TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.text.withOpacity(0.7),
            letterSpacing: 0.5,
          )
        : const TextStyle(
            fontSize: 14,
            color: AppColors.text,
          );
    
    final totalStyle = isHeader
        ? textStyle
        : const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          );

    Widget content = Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Item number (optional)
          if (itemNumber != null && !isHeader) ...[
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                itemNumber.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          // Description (flexible)
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: textStyle,
              maxLines: isHeader ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          
          // Quantity
          SizedBox(
            width: 50,
            child: Text(
              quantity,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          
          // Unit Price
          Expanded(
            flex: 2,
            child: Text(
              unitPrice,
              style: textStyle,
              textAlign: isRTL ? TextAlign.left : TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          
          // Total
          Expanded(
            flex: 2,
            child: Text(
              total,
              style: totalStyle,
              textAlign: isRTL ? TextAlign.left : TextAlign.right,
            ),
          ),
          
          // Delete button (if callback provided)
          if (onDelete != null && !isHeader) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDelete,
              color: AppColors.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ],
      ),
    );

    // Wrap with InkWell if tappable
    if (onTap != null && !isHeader) {
      content = InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return Column(
      children: [
        content,
        if (showDivider)
          Divider(
            height: 1,
            thickness: isHeader ? 1.5 : 0.5,
            color: isHeader ? AppColors.border : AppColors.border.withOpacity(0.5),
          ),
      ],
    );
  }
}

/// Compact line item for mobile view
class CompactLineItem extends StatelessWidget {
  /// Item description
  final String description;
  
  /// Item quantity
  final String quantity;
  
  /// Item total amount
  final String total;
  
  /// Optional item number
  final int? itemNumber;
  
  /// Optional callback when tapped
  final VoidCallback? onTap;

  const CompactLineItem({
    super.key,
    required this.description,
    required this.quantity,
    required this.total,
    this.itemNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (itemNumber != null) ...[
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  itemNumber.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              total,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Line items summary (subtotal, tax, total)
class LineItemsSummary extends StatelessWidget {
  /// Subtotal amount
  final String subtotal;
  
  /// Tax amount
  final String? tax;
  
  /// Tax label (e.g., "VAT 15%")
  final String? taxLabel;
  
  /// Discount amount
  final String? discount;
  
  /// Total amount
  final String total;
  
  /// Optional additional fees
  final Map<String, String>? additionalFees;
  
  /// Padding around the summary
  final EdgeInsetsGeometry? padding;

  const LineItemsSummary({
    super.key,
    required this.subtotal,
    this.tax,
    this.taxLabel,
    this.discount,
    required this.total,
    this.additionalFees,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Subtotal
          _buildSummaryRow(
            'Subtotal',
            subtotal,
            isRTL: isRTL,
          ),
          
          // Tax
          if (tax != null) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              taxLabel ?? 'Tax',
              tax!,
              isRTL: isRTL,
            ),
          ],
          
          // Discount
          if (discount != null) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount',
              discount!,
              isRTL: isRTL,
              valueColor: AppColors.success,
            ),
          ],
          
          // Additional fees
          if (additionalFees != null)
            ...additionalFees!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildSummaryRow(
                  entry.key,
                  entry.value,
                  isRTL: isRTL,
                ),
              );
            }),
          
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),
          
          // Total
          _buildSummaryRow(
            'Total',
            total,
            isRTL: isRTL,
            isBold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    required bool isRTL,
    bool isBold = false,
    double fontSize = 14,
    Color? valueColor,
  }) {
    final labelStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      color: AppColors.text.withOpacity(0.7),
    );
    
    final valueStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
      color: valueColor ?? AppColors.secondary,
    );
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

/// Editable line item with input fields
class EditableLineItem extends StatelessWidget {
  /// Description controller
  final TextEditingController descriptionController;
  
  /// Quantity controller
  final TextEditingController quantityController;
  
  /// Unit price controller
  final TextEditingController unitPriceController;
  
  /// Calculated total
  final String total;
  
  /// Optional item number
  final int? itemNumber;
  
  /// Callback when delete is pressed
  final VoidCallback? onDelete;
  
  /// Callback when values change
  final VoidCallback? onChanged;

  const EditableLineItem({
    super.key,
    required this.descriptionController,
    required this.quantityController,
    required this.unitPriceController,
    required this.total,
    this.itemNumber,
    this.onDelete,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (itemNumber != null) ...[
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    itemNumber.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        isDense: true,
                      ),
                      onChanged: (_) => onChanged?.call(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Qty',
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => onChanged?.call(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: unitPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => onChanged?.call(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: Text(
                            total,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  color: AppColors.error,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }
}
