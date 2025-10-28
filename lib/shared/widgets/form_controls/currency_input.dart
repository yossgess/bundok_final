import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Currency input field with automatic formatting
/// 
/// Features:
/// - ThemedTextInput with currency formatting (e.g., $1,250.00)
/// - Auto-format on blur
/// - Supports multiple currencies
/// - Decimal precision control
/// - Optional currency symbol
class CurrencyInput extends StatefulWidget {
  /// Initial value
  final double? initialValue;
  
  /// Callback when value changes
  final ValueChanged<double?>? onChanged;
  
  /// Field label
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Helper text
  final String? helperText;
  
  /// Error text
  final String? errorText;
  
  /// Currency symbol (e.g., '\$', '€', '£')
  final String currencySymbol;
  
  /// Currency code (e.g., 'USD', 'EUR', 'GBP')
  final String? currencyCode;
  
  /// Number of decimal places
  final int decimalDigits;
  
  /// Whether to use grouping separator (e.g., 1,000)
  final bool useGrouping;
  
  /// Whether field is required
  final bool required;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether field is read-only
  final bool readOnly;
  
  /// Optional validator
  final String? Function(double?)? validator;
  
  /// Minimum value
  final double? minValue;
  
  /// Maximum value
  final double? maxValue;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;
  
  /// Spacing between label and input
  final double spacing;

  const CurrencyInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.currencySymbol = '\$',
    this.currencyCode,
    this.decimalDigits = 2,
    this.useGrouping = true,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.minValue,
    this.maxValue,
    this.focusNode,
    this.padding,
    this.spacing = 8.0,
  });

  @override
  State<CurrencyInput> createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null 
          ? _formatCurrency(widget.initialValue!) 
          : '',
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });

    if (!_hasFocus) {
      // Format on blur
      _formatInput();
    }
  }

  void _formatInput() {
    final value = _parseValue(_controller.text);
    if (value != null) {
      _controller.text = _formatCurrency(value);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: widget.currencySymbol,
      decimalDigits: widget.decimalDigits,
      locale: 'en_US',
    );
    
    if (!widget.useGrouping) {
      return '${widget.currencySymbol}${value.toStringAsFixed(widget.decimalDigits)}';
    }
    
    return formatter.format(value);
  }

  double? _parseValue(String text) {
    if (text.isEmpty) return null;
    
    // Remove currency symbol and whitespace
    String cleaned = text
        .replaceAll(widget.currencySymbol, '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    
    return double.tryParse(cleaned);
  }

  void _onTextChanged(String text) {
    final value = _parseValue(text);
    
    // Validate
    if (widget.validator != null) {
      setState(() {
        _validationError = widget.validator!(value);
      });
    }
    
    // Check min/max
    if (value != null) {
      if (widget.minValue != null && value < widget.minValue!) {
        setState(() {
          _validationError = 'Minimum value is ${_formatCurrency(widget.minValue!)}';
        });
      } else if (widget.maxValue != null && value > widget.maxValue!) {
        setState(() {
          _validationError = 'Maximum value is ${_formatCurrency(widget.maxValue!)}';
        });
      }
    }
    
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveError = widget.errorText ?? _validationError;
    final hasError = effectiveError != null;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          if (widget.label != null) ...[
            Row(
              children: [
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                if (widget.required) ...[
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
            SizedBox(height: widget.spacing),
          ],
          
          // Input field
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s\$€£¥₹]')),
            ],
            onChanged: _onTextChanged,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: widget.hint ?? '${widget.currencySymbol}0.00',
              helperText: widget.helperText,
              errorText: effectiveError,
              filled: true,
              fillColor: widget.enabled 
                  ? AppColors.background 
                  : AppColors.border.withOpacity(0.3),
              prefixIcon: Icon(
                Icons.attach_money,
                color: widget.enabled 
                    ? AppColors.secondary 
                    : AppColors.text.withOpacity(0.5),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
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

/// Simple number input with formatting
class NumberInput extends StatefulWidget {
  /// Initial value
  final num? initialValue;
  
  /// Callback when value changes
  final ValueChanged<num?>? onChanged;
  
  /// Field label
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Whether to allow decimals
  final bool allowDecimals;
  
  /// Number of decimal places
  final int decimalDigits;
  
  /// Minimum value
  final num? minValue;
  
  /// Maximum value
  final num? maxValue;
  
  /// Step increment for +/- buttons
  final num? step;
  
  /// Whether to show +/- buttons
  final bool showSteppers;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;

  const NumberInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.label,
    this.hint,
    this.allowDecimals = true,
    this.decimalDigits = 2,
    this.minValue,
    this.maxValue,
    this.step,
    this.showSteppers = false,
    this.enabled = true,
    this.padding,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late TextEditingController _controller;
  num? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(
      text: _currentValue?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    final step = widget.step ?? 1;
    final newValue = (_currentValue ?? 0) + step;
    
    if (widget.maxValue == null || newValue <= widget.maxValue!) {
      _updateValue(newValue);
    }
  }

  void _decrement() {
    final step = widget.step ?? 1;
    final newValue = (_currentValue ?? 0) - step;
    
    if (widget.minValue == null || newValue >= widget.minValue!) {
      _updateValue(newValue);
    }
  }

  void _updateValue(num value) {
    setState(() {
      _currentValue = value;
      _controller.text = widget.allowDecimals
          ? value.toStringAsFixed(widget.decimalDigits)
          : value.toInt().toString();
    });
    widget.onChanged?.call(value);
  }

  void _onTextChanged(String text) {
    if (text.isEmpty) {
      _currentValue = null;
      widget.onChanged?.call(null);
      return;
    }
    
    final value = widget.allowDecimals 
        ? double.tryParse(text) 
        : int.tryParse(text);
    
    if (value != null) {
      _currentValue = value;
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              if (widget.showSteppers) ...[
                IconButton(
                  onPressed: widget.enabled ? _decrement : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.border.withOpacity(0.3),
                    foregroundColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: widget.allowDecimals,
                  ),
                  inputFormatters: [
                    if (widget.allowDecimals)
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    else
                      FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: _onTextChanged,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint ?? '0',
                    filled: true,
                    fillColor: widget.enabled 
                        ? AppColors.background 
                        : AppColors.border.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
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
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.showSteppers) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: widget.enabled ? _increment : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.border.withOpacity(0.3),
                    foregroundColor: AppColors.secondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
