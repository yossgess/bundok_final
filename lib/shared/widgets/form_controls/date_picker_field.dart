import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Date picker field component
/// 
/// Features:
/// - Button that opens showDatePicker
/// - Shows formatted date (localized)
/// - Optional date range constraints
/// - Clear button support
/// - Customizable date format
class DatePickerField extends StatefulWidget {
  /// Selected date
  final DateTime? selectedDate;
  
  /// Callback when date is selected
  final ValueChanged<DateTime?>? onDateSelected;
  
  /// Field label
  final String? label;
  
  /// Hint text when no date selected
  final String? hint;
  
  /// Date format pattern (defaults to localized medium date)
  final String? dateFormat;
  
  /// First selectable date
  final DateTime? firstDate;
  
  /// Last selectable date
  final DateTime? lastDate;
  
  /// Initial date to show in picker
  final DateTime? initialDate;
  
  /// Whether field is required
  final bool required;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Optional prefix icon
  final IconData? prefixIcon;
  
  /// Optional validator
  final String? Function(DateTime?)? validator;
  
  /// Error text
  final String? errorText;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;
  
  /// Spacing between label and button
  final double spacing;

  const DatePickerField({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.label,
    this.hint = 'Select date',
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.required = false,
    this.enabled = true,
    this.showClearButton = true,
    this.prefixIcon = Icons.calendar_today,
    this.validator,
    this.errorText,
    this.padding,
    this.spacing = 8.0,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  String? _validationError;

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? 
                   widget.initialDate ?? 
                   DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.background,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDateSelected?.call(picked);
      _validate(picked);
    }
  }

  void _clearDate() {
    widget.onDateSelected?.call(null);
    _validate(null);
  }

  void _validate(DateTime? date) {
    if (widget.validator != null) {
      setState(() {
        _validationError = widget.validator!(date);
      });
    }
  }

  String _formatDate(DateTime date) {
    if (widget.dateFormat != null) {
      return DateFormat(widget.dateFormat).format(date);
    }
    return DateFormat.yMMMd().format(date);
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
          
          // Date picker button
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.enabled 
                    ? AppColors.background 
                    : AppColors.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasError 
                      ? AppColors.error 
                      : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[
                    Icon(
                      widget.prefixIcon,
                      size: 20,
                      color: widget.enabled 
                          ? AppColors.secondary 
                          : AppColors.text.withOpacity(0.5),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      widget.selectedDate != null
                          ? _formatDate(widget.selectedDate!)
                          : widget.hint ?? 'Select date',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.selectedDate != null
                            ? AppColors.text
                            : AppColors.text.withOpacity(0.5),
                      ),
                    ),
                  ),
                  if (widget.showClearButton && 
                      widget.selectedDate != null && 
                      widget.enabled) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _clearDate,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Error text
          if (hasError) ...[
            const SizedBox(height: 6),
            Text(
              effectiveError,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Date range picker field
class DateRangePickerField extends StatefulWidget {
  /// Selected date range
  final DateTimeRange? selectedRange;
  
  /// Callback when range is selected
  final ValueChanged<DateTimeRange?>? onRangeSelected;
  
  /// Field label
  final String? label;
  
  /// Hint text when no range selected
  final String? hint;
  
  /// Date format pattern
  final String? dateFormat;
  
  /// First selectable date
  final DateTime? firstDate;
  
  /// Last selectable date
  final DateTime? lastDate;
  
  /// Whether field is required
  final bool required;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;

  const DateRangePickerField({
    super.key,
    this.selectedRange,
    this.onRangeSelected,
    this.label,
    this.hint = 'Select date range',
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.required = false,
    this.enabled = true,
    this.showClearButton = true,
    this.padding,
  });

  @override
  State<DateRangePickerField> createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  Future<void> _selectRange(BuildContext context) async {
    if (!widget.enabled) return;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      initialDateRange: widget.selectedRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.background,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onRangeSelected?.call(picked);
    }
  }

  void _clearRange() {
    widget.onRangeSelected?.call(null);
  }

  String _formatRange(DateTimeRange range) {
    final format = widget.dateFormat != null 
        ? DateFormat(widget.dateFormat) 
        : DateFormat.yMMMd();
    return '${format.format(range.start)} - ${format.format(range.end)}';
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
            const SizedBox(height: 8),
          ],
          InkWell(
            onTap: () => _selectRange(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.enabled 
                    ? AppColors.background 
                    : AppColors.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    size: 20,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.selectedRange != null
                          ? _formatRange(widget.selectedRange!)
                          : widget.hint ?? 'Select date range',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.selectedRange != null
                            ? AppColors.text
                            : AppColors.text.withOpacity(0.5),
                      ),
                    ),
                  ),
                  if (widget.showClearButton && 
                      widget.selectedRange != null && 
                      widget.enabled) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _clearRange,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Time picker field
class TimePickerField extends StatefulWidget {
  /// Selected time
  final TimeOfDay? selectedTime;
  
  /// Callback when time is selected
  final ValueChanged<TimeOfDay?>? onTimeSelected;
  
  /// Field label
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Whether field is required
  final bool required;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Padding around the field
  final EdgeInsetsGeometry? padding;

  const TimePickerField({
    super.key,
    this.selectedTime,
    this.onTimeSelected,
    this.label,
    this.hint = 'Select time',
    this.required = false,
    this.enabled = true,
    this.showClearButton = true,
    this.padding,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  Future<void> _selectTime(BuildContext context) async {
    if (!widget.enabled) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.background,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onTimeSelected?.call(picked);
    }
  }

  void _clearTime() {
    widget.onTimeSelected?.call(null);
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
            const SizedBox(height: 8),
          ],
          InkWell(
            onTap: () => _selectTime(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.enabled 
                    ? AppColors.background 
                    : AppColors.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 20,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.selectedTime != null
                          ? widget.selectedTime!.format(context)
                          : widget.hint ?? 'Select time',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.selectedTime != null
                            ? AppColors.text
                            : AppColors.text.withOpacity(0.5),
                      ),
                    ),
                  ),
                  if (widget.showClearButton && 
                      widget.selectedTime != null && 
                      widget.enabled) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _clearTime,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
