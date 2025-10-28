import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/material.dart' as material show TextButton;
import '../../../core/constants/app_colors.dart';

/// Text button with no background for tertiary actions
/// 
/// Features:
/// - No background, colored text (AppColors.primary)
/// - Used for "Cancel", "Edit", "Learn more" actions
/// - Loading state with spinner
/// - Disabled state with reduced opacity
/// - Optional leading/trailing icons
/// - Compact padding for inline use
class TextButton extends StatelessWidget {
  /// Button label text
  final String label;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Whether button is in loading state
  final bool isLoading;
  
  /// Optional leading icon
  final IconData? leadingIcon;
  
  /// Optional trailing icon
  final IconData? trailingIcon;
  
  /// Optional custom padding
  final EdgeInsetsGeometry? padding;
  
  /// Optional custom text color (defaults to AppColors.primary)
  final Color? textColor;
  
  /// Optional font size
  final double? fontSize;
  
  /// Optional font weight
  final FontWeight? fontWeight;
  
  /// Whether to underline text on hover
  final bool underlineOnHover;

  const TextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.underlineOnHover = false,
  });

  /// Small text button with compact padding
  const TextButton.small({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.textColor,
    this.underlineOnHover = false,
  })  : padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        fontSize = 12,
        fontWeight = FontWeight.w500;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final effectiveTextColor = textColor ?? AppColors.primary;
    final effectiveFontSize = fontSize ?? 14;
    final effectiveFontWeight = fontWeight ?? FontWeight.w600;
    
    return material.TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: material.TextButton.styleFrom(
        foregroundColor: effectiveTextColor,
        disabledForegroundColor: effectiveTextColor.withOpacity(0.5),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              ),
            )
          else if (leadingIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                leadingIcon,
                size: 18,
                color: effectiveTextColor,
              ),
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: effectiveFontSize,
              fontWeight: effectiveFontWeight,
              color: effectiveTextColor,
              decoration: underlineOnHover ? TextDecoration.underline : null,
            ),
          ),
          if (!isLoading && trailingIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(
                trailingIcon,
                size: 18,
                color: effectiveTextColor,
              ),
            ),
        ],
      ),
    );
  }
}
