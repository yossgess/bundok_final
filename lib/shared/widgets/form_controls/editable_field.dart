import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// Editable field component with label and input
/// 
/// Features:
/// - Label + ThemedTextInput in column layout
/// - Optional validation error display
/// - Consistent spacing and styling
/// - Support for various input types
/// - Optional prefix/suffix icons
class EditableField extends StatelessWidget {
  /// Field label
  final String label;
  
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Initial value (if controller not provided)
  final String? initialValue;
  
  /// Hint text
  final String? hint;
  
  /// Helper text
  final String? helperText;
  
  /// Validation error text
  final String? errorText;
  
  /// Whether field is required
  final bool required;
  
  /// Callback when value changes
  final ValueChanged<String>? onChanged;
  
  /// Callback when editing is complete
  final VoidCallback? onEditingComplete;
  
  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Validator function
  final String? Function(String?)? validator;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Whether to obscure text (passwords)
  final bool obscureText;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether field is read-only
  final bool readOnly;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Maximum length
  final int? maxLength;
  
  /// Whether to show character counter
  final bool showCounter;
  
  /// Optional prefix icon
  final IconData? prefixIcon;
  
  /// Optional suffix icon
  final IconData? suffixIcon;
  
  /// Optional suffix icon callback
  final VoidCallback? onSuffixIconPressed;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Label text style
  final TextStyle? labelStyle;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;
  
  /// Spacing between label and input
  final double spacing;

  const EditableField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helperText,
    this.errorText,
    this.required = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
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
    this.inputFormatters,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.labelStyle,
    this.padding,
    this.spacing = 8.0,
  });

  /// Email field variant
  const EditableField.email({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint = 'Enter email address',
    this.helperText,
    this.errorText,
    this.required = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.labelStyle,
    this.padding,
    this.spacing = 8.0,
  })  : keyboardType = TextInputType.emailAddress,
        textInputAction = TextInputAction.next,
        obscureText = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        showCounter = false,
        prefixIcon = Icons.email_outlined,
        suffixIcon = null,
        onSuffixIconPressed = null,
        inputFormatters = null,
        textCapitalization = TextCapitalization.none;

  /// Phone field variant
  const EditableField.phone({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint = 'Enter phone number',
    this.helperText,
    this.errorText,
    this.required = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.labelStyle,
    this.padding,
    this.spacing = 8.0,
  })  : keyboardType = TextInputType.phone,
        textInputAction = TextInputAction.next,
        obscureText = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        showCounter = false,
        prefixIcon = Icons.phone_outlined,
        suffixIcon = null,
        onSuffixIconPressed = null,
        inputFormatters = null,
        textCapitalization = TextCapitalization.none;

  /// Multiline text field variant
  const EditableField.multiline({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helperText,
    this.errorText,
    this.required = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.showCounter = false,
    this.focusNode,
    this.labelStyle,
    this.padding,
    this.spacing = 8.0,
  })  : keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        obscureText = false,
        maxLines = 5,
        minLines = 3,
        prefixIcon = null,
        suffixIcon = null,
        onSuffixIconPressed = null,
        inputFormatters = null,
        textCapitalization = TextCapitalization.sentences;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = labelStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.text,
        );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label with required indicator
          Row(
            children: [
              Text(
                label,
                style: effectiveLabelStyle,
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: spacing),
          
          // Input field
          TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
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
            onFieldSubmitted: onSubmitted,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: hint,
              helperText: helperText,
              errorText: errorText,
              filled: true,
              fillColor: enabled 
                  ? AppColors.background 
                  : AppColors.border.withOpacity(0.3),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.secondary, size: 20)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon, color: AppColors.secondary, size: 20),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 12 : 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Form field group for organizing multiple fields
class FieldGroup extends StatelessWidget {
  /// Group title
  final String? title;
  
  /// List of fields
  final List<Widget> children;
  
  /// Spacing between fields
  final double spacing;
  
  /// Padding around the group
  final EdgeInsetsGeometry? padding;
  
  /// Whether to show divider after title
  final bool showDivider;

  const FieldGroup({
    super.key,
    this.title,
    required this.children,
    this.spacing = 16.0,
    this.padding,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            if (showDivider) ...[
              const SizedBox(height: 8),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border,
              ),
            ],
            SizedBox(height: spacing),
          ],
          ...List.generate(children.length, (index) {
            final isLast = index == children.length - 1;
            return Column(
              children: [
                children[index],
                if (!isLast) SizedBox(height: spacing),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// Inline editable field (label and input on same row)
class InlineEditableField extends StatelessWidget {
  /// Field label
  final String label;
  
  /// Text editing controller
  final TextEditingController? controller;
  
  /// Hint text
  final String? hint;
  
  /// Callback when value changes
  final ValueChanged<String>? onChanged;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Label width
  final double labelWidth;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;

  const InlineEditableField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.onChanged,
    this.keyboardType,
    this.enabled = true,
    this.labelWidth = 120.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
