import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Button style variant
enum SecondaryButtonVariant {
  /// Outlined style with border
  outlined,
  
  /// Ghost style with no background or border
  ghost,
}

/// Secondary action button with outline or ghost style
/// 
/// Features:
/// - Outline variant: border AppColors.border (#F2FDFF), text AppColors.secondary
/// - Ghost variant: no background/border, colored text for subtle actions
/// - Loading state with spinner
/// - Disabled state with reduced opacity
/// - Optional leading/trailing icons
/// - Consistent padding and rounded corners (8dp)
class SecondaryButton extends StatelessWidget {
  /// Button label text
  final String label;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Button style variant
  final SecondaryButtonVariant variant;
  
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
  
  /// Optional custom text color
  final Color? textColor;
  
  /// Optional custom border color (outline variant only)
  final Color? borderColor;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SecondaryButtonVariant.outlined,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.padding,
    this.height,
    this.borderRadius,
    this.textColor,
    this.borderColor,
  });

  /// Outlined secondary button
  const SecondaryButton.outlined({
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
    this.textColor,
    this.borderColor,
  }) : variant = SecondaryButtonVariant.outlined;

  /// Ghost secondary button (no border, subtle)
  const SecondaryButton.ghost({
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
    this.textColor,
    this.borderColor,
  }) : variant = SecondaryButtonVariant.ghost;

  /// Full-width outlined button
  const SecondaryButton.fullWidth({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SecondaryButtonVariant.outlined,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.height,
    this.borderRadius,
    this.textColor,
    this.borderColor,
  }) : fullWidth = true;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final effectiveTextColor = textColor ?? AppColors.secondary;
    final effectiveBorderColor = borderColor ?? AppColors.border;
    
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
    
    final button = variant == SecondaryButtonVariant.outlined
        ? OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: effectiveTextColor,
              disabledForegroundColor: effectiveTextColor.withOpacity(0.5),
              side: BorderSide(
                color: isDisabled
                    ? effectiveBorderColor.withOpacity(0.5)
                    : effectiveBorderColor,
                width: 1.5,
              ),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: height != null ? Size(0, height!) : const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
            ),
            child: buttonContent,
          )
        : TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: effectiveTextColor,
              disabledForegroundColor: effectiveTextColor.withOpacity(0.5),
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
