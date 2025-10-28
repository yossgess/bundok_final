import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Toast notification component
/// 
/// Features:
/// - Temporary bottom snackbar: "Invoice saved!"
/// - Auto-dismiss with configurable duration
/// - Optional action button ("Undo")
/// - Different types (success, error, info, warning)
/// - Customizable styling
class Toast {
  /// Show a toast message
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    ToastType type = ToastType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    IconData? icon,
    bool showCloseButton = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            if (showCloseButton)
              IconButton(
                onPressed: () => messenger.hideCurrentSnackBar(),
                icon: const Icon(Icons.close, size: 18),
                color: Colors.white,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
          ],
        ),
        backgroundColor: _getBackgroundColor(type),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show success toast
  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      type: ToastType.success,
      icon: Icons.check_circle,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show error toast
  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      type: ToastType.error,
      icon: Icons.error,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show warning toast
  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      type: ToastType.warning,
      icon: Icons.warning,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show info toast
  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      type: ToastType.info,
      icon: Icons.info,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show loading toast
  static void loading(
    BuildContext context, {
    required String message,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.secondary,
        duration: const Duration(days: 1), // Won't auto-dismiss
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Hide current toast
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Get background color for toast type
  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.error;
      case ToastType.warning:
        return AppColors.warning;
      case ToastType.info:
        return AppColors.primary;
    }
  }
}

/// Toast type enum
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Custom toast widget for more control
class CustomToast extends StatelessWidget {
  /// Toast message
  final String message;
  
  /// Toast type
  final ToastType type;
  
  /// Optional icon
  final IconData? icon;
  
  /// Optional action label
  final String? actionLabel;
  
  /// Optional action callback
  final VoidCallback? onActionPressed;
  
  /// Whether to show close button
  final bool showCloseButton;
  
  /// Background color
  final Color? backgroundColor;

  const CustomToast({
    super.key,
    required this.message,
    this.type = ToastType.info,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
    this.showCloseButton = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? _getBackgroundColor();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (showCloseButton) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, size: 18),
              color: Colors.white,
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
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.error;
      case ToastType.warning:
        return AppColors.warning;
      case ToastType.info:
        return AppColors.primary;
    }
  }
}

/// Toast overlay for custom positioning
class ToastOverlay {
  /// Show toast overlay
  static OverlayEntry? _currentOverlay;

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    ToastType type = ToastType.info,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    ToastPosition position = ToastPosition.bottom,
  }) {
    // Remove existing overlay
    _currentOverlay?.remove();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        top: position == ToastPosition.top ? 50 : null,
        bottom: position == ToastPosition.bottom ? 50 : null,
        child: Material(
          color: Colors.transparent,
          child: CustomToast(
            message: message,
            type: type,
            icon: icon,
            actionLabel: actionLabel,
            onActionPressed: onActionPressed,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _currentOverlay = overlayEntry;

    // Auto-dismiss
    Future.delayed(duration, () {
      overlayEntry.remove();
      if (_currentOverlay == overlayEntry) {
        _currentOverlay = null;
      }
    });
  }

  /// Hide current overlay
  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

/// Toast position enum
enum ToastPosition {
  top,
  bottom,
}

/// Common toast messages
class ToastMessages {
  /// Invoice saved
  static void invoiceSaved(BuildContext context, {VoidCallback? onUndo}) {
    Toast.success(
      context,
      message: 'Invoice saved!',
      actionLabel: onUndo != null ? 'Undo' : null,
      onActionPressed: onUndo,
    );
  }

  /// Invoice deleted
  static void invoiceDeleted(BuildContext context, {VoidCallback? onUndo}) {
    Toast.success(
      context,
      message: 'Invoice deleted',
      actionLabel: onUndo != null ? 'Undo' : null,
      onActionPressed: onUndo,
    );
  }

  /// Export success
  static void exportSuccess(BuildContext context) {
    Toast.success(
      context,
      message: 'Export successful!',
    );
  }

  /// Network error
  static void networkError(BuildContext context, {VoidCallback? onRetry}) {
    Toast.error(
      context,
      message: 'Network error. Please try again.',
      actionLabel: onRetry != null ? 'Retry' : null,
      onActionPressed: onRetry,
    );
  }

  /// Copied to clipboard
  static void copiedToClipboard(BuildContext context) {
    Toast.info(
      context,
      message: 'Copied to clipboard',
      duration: const Duration(seconds: 2),
    );
  }

  /// Changes saved
  static void changesSaved(BuildContext context) {
    Toast.success(
      context,
      message: 'Changes saved successfully',
    );
  }

  /// Processing
  static void processing(BuildContext context, String message) {
    Toast.loading(
      context,
      message: message,
    );
  }
}
