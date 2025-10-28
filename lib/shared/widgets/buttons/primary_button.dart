import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Primary action button with solid fill and loading state support
/// 
/// Features:
/// - Solid fill with AppColors.primary (#7BBBFF)
/// - Loading state with spinner
/// - Disabled state with reduced opacity
/// - Optional leading/trailing icons
/// - Consistent padding and rounded corners (8dp)
/// - Full-width or auto-sized variants
class PrimaryButton extends StatelessWidget {
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
  
  /// Whether button should expand to full width
  final bool fullWidth;
  
  /// Optional custom padding
  final EdgeInsetsGeometry? padding;
  
  /// Optional custom height
  final double? height;
  
  /// Optional custom border radius
  final double? borderRadius;
  
  /// Optional custom background color
  final Color? backgroundColor;
  
  /// Optional custom text color
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.padding,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  });

  /// Full-width primary button
  const PrimaryButton.fullWidth({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  }) : fullWidth = true;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? Colors.white;
    
    Widget buttonContent = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        else if (leadingIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              leadingIcon,
              size: 20,
              color: effectiveTextColor,
            ),
          ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: effectiveTextColor,
          ),
        ),
        if (!isLoading && trailingIcon != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              trailingIcon,
              size: 20,
              color: effectiveTextColor,
            ),
          ),
      ],
    );
    
    final button = ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveTextColor,
        disabledBackgroundColor: effectiveBackgroundColor.withOpacity(0.5),
        disabledForegroundColor: effectiveTextColor.withOpacity(0.5),
        elevation: isDisabled ? 0 : 2,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: height != null ? Size(0, height!) : const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: buttonContent,
    );
    
    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }
}
