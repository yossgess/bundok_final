import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// Styled text input field with consistent theming and RTL support
/// 
/// Features:
/// - Border: AppColors.border with focus state (AppColors.primary)
/// - Rounded corners (8dp) and consistent padding
/// - Error state support with validation messages
/// - RTL text direction support
/// - Optional prefix/suffix icons
/// - Optional character counter
/// - Support for multiline text
/// - Input formatters and validators
class ThemedTextInput extends StatelessWidget {
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Label text displayed above the field
  final String? label;
  
  /// Hint text displayed when field is empty
  final String? hint;
  
  /// Helper text displayed below the field
  final String? helperText;
  
  /// Error text displayed when validation fails
  final String? errorText;
  
  /// Callback when text changes
  final ValueChanged<String>? onChanged;
  
  /// Callback when editing is complete
  final VoidCallback? onEditingComplete;
  
  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Whether to obscure text (for passwords)
  final bool obscureText;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether field is read-only
  final bool readOnly;
  
  /// Maximum number of lines (null for unlimited)
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Maximum length of text
  final int? maxLength;
  
  /// Whether to show character counter
  final bool showCounter;
  
  /// Optional prefix icon
  final IconData? prefixIcon;
  
  /// Optional suffix icon
  final IconData? suffixIcon;
  
  /// Optional suffix icon button callback
  final VoidCallback? onSuffixIconPressed;
  
  /// Optional prefix widget
  final Widget? prefix;
  
  /// Optional suffix widget
  final Widget? suffix;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Auto-validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Validator function
  final String? Function(String?)? validator;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Optional custom border radius
  final double? borderRadius;
  
  /// Optional custom padding
  final EdgeInsetsGeometry? contentPadding;

  const ThemedTextInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.autovalidateMode,
    this.validator,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.borderRadius,
    this.contentPadding,
  });

  /// Multiline text input
  const ThemedTextInput.multiline({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.showCounter = false,
    this.inputFormatters,
    this.autovalidateMode,
    this.validator,
    this.focusNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.borderRadius,
    this.contentPadding,
  })  : keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        obscureText = false,
        maxLines = 5,
        minLines = 3,
        prefixIcon = null,
        suffixIcon = null,
        onSuffixIconPressed = null,
        prefix = null,
        suffix = null;

  /// Password input with toggle visibility
  const ThemedTextInput.password({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.inputFormatters,
    this.autovalidateMode,
    this.validator,
    this.focusNode,
    this.borderRadius,
    this.contentPadding,
  })  : obscureText = true,
        keyboardType = TextInputType.visiblePassword,
        textInputAction = TextInputAction.done,
        maxLines = 1,
        minLines = null,
        showCounter = false,
        prefixIcon = Icons.lock_outline,
        suffixIcon = null,
        onSuffixIconPressed = null,
        prefix = null,
        suffix = null,
        textCapitalization = TextCapitalization.none;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: showCounter ? maxLength : null,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: enabled ? AppColors.background : AppColors.border.withOpacity(0.3),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.secondary, size: 20)
                : null,
            prefix: prefix,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: AppColors.secondary, size: 20),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            suffix: suffix,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: prefixIcon != null || prefix != null ? 12 : 16,
                  vertical: 12,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Form field variant with validation support
class ThemedTextFormField extends FormField<String> {
  ThemedTextFormField({
    super.key,
    TextEditingController? controller,
    String? label,
    String? hint,
    String? helperText,
    String? initialValue,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    bool enabled = true,
    bool readOnly = false,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    bool showCounter = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    Widget? prefix,
    Widget? suffix,
    List<TextInputFormatter>? inputFormatters,
    AutovalidateMode? autovalidateMode,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    TextCapitalization textCapitalization = TextCapitalization.none,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) : super(
          initialValue: controller != null ? controller.text : (initialValue ?? ''),
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (FormFieldState<String> field) {
            return ThemedTextInput(
              controller: controller,
              label: label,
              hint: hint,
              helperText: helperText,
              errorText: field.errorText,
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              obscureText: obscureText,
              enabled: enabled,
              readOnly: readOnly,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              showCounter: showCounter,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              onSuffixIconPressed: onSuffixIconPressed,
              prefix: prefix,
              suffix: suffix,
              inputFormatters: inputFormatters,
              focusNode: focusNode,
              textCapitalization: textCapitalization,
              borderRadius: borderRadius,
              contentPadding: contentPadding,
            );
          },
        );
}
