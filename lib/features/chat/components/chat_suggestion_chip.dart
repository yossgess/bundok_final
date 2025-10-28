import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Chat suggestion chip component
/// 
/// Features:
/// - Predefined queries: "Show unpaid invoices", "Total last month?"
/// - Pressable TagChip style
/// - Optional icon support
/// - Grouped suggestions
class ChatSuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final SuggestionChipSize size;

  const ChatSuggestionChip({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.size = SuggestionChipSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        AppColors.accent.withOpacity(0.1);
    final effectiveTextColor = textColor ?? AppColors.secondary;
    final effectiveBorderColor = borderColor ?? 
        AppColors.accent.withOpacity(0.3);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size.height / 2),
      child: Container(
        padding: size.padding,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(size.height / 2),
          border: Border.all(color: effectiveBorderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: size.iconSize, color: effectiveTextColor),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: size.fontSize,
                  fontWeight: FontWeight.w500,
                  color: effectiveTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SuggestionChipSize {
  small(28.0, 12.0, 16.0, EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
  medium(36.0, 14.0, 18.0, EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
  large(44.0, 16.0, 20.0, EdgeInsets.symmetric(horizontal: 20, vertical: 10));

  const SuggestionChipSize(this.height, this.fontSize, this.iconSize, this.padding);
  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
}

class ChatSuggestion {
  final String text;
  final IconData? icon;

  const ChatSuggestion({required this.text, this.icon});
}

class SuggestionChipGroup extends StatelessWidget {
  final List<ChatSuggestion> suggestions;
  final ValueChanged<String>? onSuggestionSelected;
  final SuggestionChipSize size;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;

  const SuggestionChipGroup({
    super.key,
    required this.suggestions,
    this.onSuggestionSelected,
    this.size = SuggestionChipSize.medium,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: suggestions.map((suggestion) {
          return ChatSuggestionChip(
            text: suggestion.text,
            icon: suggestion.icon,
            size: size,
            onPressed: onSuggestionSelected != null
                ? () => onSuggestionSelected!(suggestion.text)
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class QuickSuggestions {
  static List<ChatSuggestion> invoiceQueries() => [
        const ChatSuggestion(text: 'Show unpaid invoices', icon: Icons.pending_actions),
        const ChatSuggestion(text: 'Total last month?', icon: Icons.calendar_month),
        const ChatSuggestion(text: 'List all vendors', icon: Icons.business),
        const ChatSuggestion(text: 'Overdue invoices', icon: Icons.warning_amber),
      ];
}
