import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'base_modal.dart';

/// Confirmation modal component
/// 
/// Features:
/// - "Are you sure?" confirmation dialog
/// - "Cancel" / "Confirm" buttons
/// - Destructive actions in red
/// - Optional custom message and icon
class ConfirmationModal extends StatelessWidget {
  /// Confirmation title
  final String title;
  
  /// Confirmation message
  final String message;
  
  /// Confirm button label
  final String confirmLabel;
  
  /// Cancel button label
  final String cancelLabel;
  
  /// Whether action is destructive (red color)
  final bool isDestructive;
  
  /// Optional icon
  final IconData? icon;
  
  /// Callback when confirmed
  final VoidCallback? onConfirm;
  
  /// Callback when cancelled
  final VoidCallback? onCancel;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.icon,
    this.onConfirm,
    this.onCancel,
  });

  /// Delete confirmation
  const ConfirmationModal.delete({
    super.key,
    this.title = 'Delete Item',
    this.message = 'Are you sure you want to delete this item? This action cannot be undone.',
    this.confirmLabel = 'Delete',
    this.cancelLabel = 'Cancel',
    this.icon = Icons.delete_outline,
    this.onConfirm,
    this.onCancel,
  }) : isDestructive = true;

  /// Discard changes confirmation
  const ConfirmationModal.discardChanges({
    super.key,
    this.title = 'Discard Changes',
    this.message = 'You have unsaved changes. Are you sure you want to discard them?',
    this.confirmLabel = 'Discard',
    this.cancelLabel = 'Keep Editing',
    this.icon = Icons.warning_amber,
    this.onConfirm,
    this.onCancel,
  }) : isDestructive = true;

  /// Logout confirmation
  const ConfirmationModal.logout({
    super.key,
    this.title = 'Logout',
    this.message = 'Are you sure you want to logout?',
    this.confirmLabel = 'Logout',
    this.cancelLabel = 'Cancel',
    this.icon = Icons.logout,
    this.onConfirm,
    this.onCancel,
  }) : isDestructive = false;

  @override
  Widget build(BuildContext context) {
    final confirmColor = isDestructive ? AppColors.error : AppColors.primary;

    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: confirmColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: confirmColor,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.7),
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
          ),
          child: Text(cancelLabel),
        ),
        
        // Confirm button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  /// Show confirmation modal
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    IconData? icon,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationModal(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        icon: icon,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  /// Show delete confirmation
  static Future<bool?> showDelete({
    required BuildContext context,
    String? itemName,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: 'Delete ${itemName ?? "Item"}',
      message: 'Are you sure you want to delete this ${itemName?.toLowerCase() ?? "item"}? This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDestructive: true,
      icon: Icons.delete_outline,
      onConfirm: onConfirm,
    );
  }
}

/// Bottom sheet confirmation variant
class ConfirmationBottomSheet extends StatelessWidget {
  /// Confirmation title
  final String title;
  
  /// Confirmation message
  final String message;
  
  /// Confirm button label
  final String confirmLabel;
  
  /// Cancel button label
  final String cancelLabel;
  
  /// Whether action is destructive
  final bool isDestructive;
  
  /// Optional icon
  final IconData? icon;
  
  /// Callback when confirmed
  final VoidCallback? onConfirm;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.icon,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final confirmColor = isDestructive ? AppColors.error : AppColors.primary;

    return BaseModal(
      title: title,
      showCloseButton: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: confirmColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: confirmColor,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.text.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
          ),
          child: Text(cancelLabel),
        ),
        
        // Confirm button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }

  /// Show as bottom sheet
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    IconData? icon,
    VoidCallback? onConfirm,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        icon: icon,
        onConfirm: onConfirm,
      ),
    );
  }
}

/// Action sheet with multiple options
class ActionSheet extends StatelessWidget {
  /// Sheet title
  final String? title;
  
  /// List of actions
  final List<ActionSheetOption> actions;
  
  /// Whether to show cancel button
  final bool showCancel;
  
  /// Cancel button label
  final String cancelLabel;

  const ActionSheet({
    super.key,
    this.title,
    required this.actions,
    this.showCancel = true,
    this.cancelLabel = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: title,
      showCloseButton: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions.map((action) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pop();
              action.onPressed?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (action.icon != null) ...[
                    Icon(
                      action.icon,
                      size: 20,
                      color: action.isDestructive 
                          ? AppColors.error 
                          : AppColors.secondary,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      action.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: action.isDestructive 
                            ? AppColors.error 
                            : AppColors.secondary,
                      ),
                    ),
                  ),
                  if (action.trailing != null) action.trailing!,
                ],
              ),
            ),
          );
        }).toList(),
      ),
      actions: showCancel
          ? [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(cancelLabel),
              ),
            ]
          : null,
    );
  }

  /// Show action sheet
  static Future<void> show({
    required BuildContext context,
    String? title,
    required List<ActionSheetOption> actions,
    bool showCancel = true,
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ActionSheet(
        title: title,
        actions: actions,
        showCancel: showCancel,
        cancelLabel: cancelLabel,
      ),
    );
  }
}

/// Action sheet option data model
class ActionSheetOption {
  final String label;
  final IconData? icon;
  final bool isDestructive;
  final VoidCallback? onPressed;
  final Widget? trailing;

  const ActionSheetOption({
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.onPressed,
    this.trailing,
  });
}
