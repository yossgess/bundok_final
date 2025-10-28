import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// Key-value row component for displaying labeled data
/// 
/// Features:
/// - Label + value layout (e.g., "Due Date: Oct 30, 2025")
/// - Label: AppColors.text (50% opacity)
/// - Value: AppColors.secondary
/// - RTL-safe layout
/// - Optional copy-to-clipboard
/// - Optional custom styling
class KeyValueRow extends StatelessWidget {
  /// Label text
  final String label;
  
  /// Value text
  final String value;
  
  /// Optional label icon
  final IconData? labelIcon;
  
  /// Optional value icon
  final IconData? valueIcon;
  
  /// Label text style override
  final TextStyle? labelStyle;
  
  /// Value text style override
  final TextStyle? valueStyle;
  
  /// Padding around the row
  final EdgeInsetsGeometry? padding;
  
  /// Spacing between label and value
  final double spacing;
  
  /// Whether to allow copying value to clipboard
  final bool copyable;
  
  /// Whether to show divider below
  final bool showDivider;
  
  /// Layout direction (horizontal or vertical)
  final KeyValueLayout layout;
  
  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.labelIcon,
    this.valueIcon,
    this.labelStyle,
    this.valueStyle,
    this.padding,
    this.spacing = 8.0,
    this.copyable = false,
    this.showDivider = false,
    this.layout = KeyValueLayout.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Vertical layout variant
  const KeyValueRow.vertical({
    super.key,
    required this.label,
    required this.value,
    this.labelIcon,
    this.valueIcon,
    this.labelStyle,
    this.valueStyle,
    this.padding,
    this.spacing = 4.0,
    this.copyable = false,
    this.showDivider = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : layout = KeyValueLayout.vertical;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.5),
        );
    
    final effectiveValueStyle = valueStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
        );

    Widget labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelIcon != null) ...[
          Icon(
            labelIcon,
            size: 16,
            color: AppColors.text.withOpacity(0.5),
          ),
          const SizedBox(width: 6),
        ],
        Text(label, style: effectiveLabelStyle),
      ],
    );

    Widget valueWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            value,
            style: effectiveValueStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (valueIcon != null) ...[
          const SizedBox(width: 6),
          Icon(
            valueIcon,
            size: 16,
            color: AppColors.secondary,
          ),
        ],
        if (copyable) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _copyToClipboard(context, value),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.copy,
                size: 14,
                color: AppColors.text.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ],
    );

    Widget content;
    if (layout == KeyValueLayout.horizontal) {
      content = Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          labelWidget,
          SizedBox(width: spacing),
          Expanded(child: valueWidget),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          labelWidget,
          SizedBox(height: spacing),
          valueWidget,
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
          child: content,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.border.withOpacity(0.5),
          ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Layout direction for key-value row
enum KeyValueLayout {
  horizontal,
  vertical,
}

/// Key-value pair list (multiple rows)
class KeyValueList extends StatelessWidget {
  /// List of key-value pairs
  final List<KeyValuePair> items;
  
  /// Padding around the list
  final EdgeInsetsGeometry? padding;
  
  /// Whether to show dividers between items
  final bool showDividers;
  
  /// Layout direction
  final KeyValueLayout layout;

  const KeyValueList({
    super.key,
    required this.items,
    this.padding,
    this.showDividers = true,
    this.layout = KeyValueLayout.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return KeyValueRow(
            label: item.label,
            value: item.value,
            labelIcon: item.labelIcon,
            valueIcon: item.valueIcon,
            copyable: item.copyable,
            showDivider: showDividers && !isLast,
            layout: layout,
          );
        }).toList(),
      ),
    );
  }
}

/// Key-value pair data model
class KeyValuePair {
  final String label;
  final String value;
  final IconData? labelIcon;
  final IconData? valueIcon;
  final bool copyable;

  const KeyValuePair({
    required this.label,
    required this.value,
    this.labelIcon,
    this.valueIcon,
    this.copyable = false,
  });
}

/// Grouped key-value section with header
class KeyValueSection extends StatelessWidget {
  /// Section title
  final String title;
  
  /// List of key-value pairs
  final List<KeyValuePair> items;
  
  /// Optional section icon
  final IconData? icon;
  
  /// Padding around the section
  final EdgeInsetsGeometry? padding;
  
  /// Whether to show dividers between items
  final bool showDividers;
  
  /// Layout direction
  final KeyValueLayout layout;

  const KeyValueSection({
    super.key,
    required this.title,
    required this.items,
    this.icon,
    this.padding,
    this.showDividers = true,
    this.layout = KeyValueLayout.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
        KeyValueList(
          items: items,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          showDividers: showDividers,
          layout: layout,
        ),
      ],
    );
  }
}

/// Highlighted key-value row (with background)
class HighlightedKeyValueRow extends StatelessWidget {
  /// Label text
  final String label;
  
  /// Value text
  final String value;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border color
  final Color? borderColor;
  
  /// Padding inside the row
  final EdgeInsetsGeometry? padding;
  
  /// Margin around the row
  final EdgeInsetsGeometry? margin;

  const HighlightedKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.text.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Editable key-value row with text field
class EditableKeyValueRow extends StatelessWidget {
  /// Label text
  final String label;
  
  /// Text editing controller
  final TextEditingController controller;
  
  /// Optional hint text
  final String? hint;
  
  /// Optional keyboard type
  final TextInputType? keyboardType;
  
  /// Optional validator
  final String? Function(String?)? validator;
  
  /// Padding around the row
  final EdgeInsetsGeometry? padding;

  const EditableKeyValueRow({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              keyboardType: keyboardType,
              validator: validator,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
