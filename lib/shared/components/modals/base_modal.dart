import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Reusable base modal component
/// 
/// Features:
/// - Title, content, actions
/// - Blurred background (iOS), elevation (Android)
/// - Customizable styling
/// - Draggable sheet support
/// - Safe area handling
class BaseModal extends StatelessWidget {
  /// Modal title
  final String? title;
  
  /// Modal content widget
  final Widget content;
  
  /// Action buttons
  final List<Widget>? actions;
  
  /// Whether modal is scrollable
  final bool isScrollable;
  
  /// Whether to show close button
  final bool showCloseButton;
  
  /// Optional custom header widget
  final Widget? header;
  
  /// Optional custom footer widget
  final Widget? footer;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border radius
  final double borderRadius;
  
  /// Maximum height factor (0.0 to 1.0)
  final double? maxHeightFactor;
  
  /// Padding around content
  final EdgeInsetsGeometry? contentPadding;
  
  /// Whether to use blur effect
  final bool useBlur;

  const BaseModal({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.isScrollable = true,
    this.showCloseButton = true,
    this.header,
    this.footer,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.maxHeightFactor,
    this.contentPadding,
    this.useBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.background;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = maxHeightFactor != null 
        ? screenHeight * maxHeightFactor! 
        : screenHeight * 0.9;

    Widget modalContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        // Header or Title
        if (header != null)
          header!
        else if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                if (showCloseButton)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.secondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
              ],
            ),
          ),
        
        // Content
        Flexible(
          child: isScrollable
              ? SingleChildScrollView(
                  padding: contentPadding ?? 
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: content,
                )
              : Padding(
                  padding: contentPadding ?? 
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: content,
                ),
        ),
        
        // Actions
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!.map((action) {
                final index = actions!.indexOf(action);
                return Padding(
                  padding: EdgeInsets.only(
                    left: index > 0 ? 12 : 0,
                  ),
                  child: action,
                );
              }).toList(),
            ),
          ),
        
        // Footer
        if (footer != null) footer!,
      ],
    );

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
      child: useBlur
          ? ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: effectiveBackgroundColor.withOpacity(0.9),
                  child: modalContent,
                ),
              ),
            )
          : modalContent,
    );
  }

  /// Show modal as bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool isScrollable = true,
    bool showCloseButton = true,
    Widget? header,
    Widget? footer,
    Color? backgroundColor,
    double borderRadius = 24.0,
    double? maxHeightFactor,
    EdgeInsetsGeometry? contentPadding,
    bool useBlur = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => BaseModal(
        title: title,
        content: content,
        actions: actions,
        isScrollable: isScrollable,
        showCloseButton: showCloseButton,
        header: header,
        footer: footer,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        maxHeightFactor: maxHeightFactor,
        contentPadding: contentPadding,
        useBlur: useBlur,
      ),
    );
  }
}

/// Full screen modal variant
class FullScreenModal extends StatelessWidget {
  /// Modal title
  final String? title;
  
  /// Modal content widget
  final Widget content;
  
  /// Action buttons
  final List<Widget>? actions;
  
  /// Whether to show back button
  final bool showBackButton;
  
  /// Background color
  final Color? backgroundColor;
  
  /// App bar actions
  final List<Widget>? appBarActions;

  const FullScreenModal({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.appBarActions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: AppBar(
        backgroundColor: backgroundColor ?? AppColors.background,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                color: AppColors.secondary,
              )
            : null,
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              )
            : null,
        actions: appBarActions,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: content),
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!.map((action) {
                    final index = actions!.indexOf(action);
                    return Padding(
                      padding: EdgeInsets.only(left: index > 0 ? 12 : 0),
                      child: action,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Show as full screen modal
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
    List<Widget>? appBarActions,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenModal(
          title: title,
          content: content,
          actions: actions,
          showBackButton: showBackButton,
          backgroundColor: backgroundColor,
          appBarActions: appBarActions,
        ),
      ),
    );
  }
}

/// Draggable modal sheet
class DraggableModal extends StatelessWidget {
  /// Modal title
  final String? title;
  
  /// Modal content widget
  final Widget content;
  
  /// Initial child size (0.0 to 1.0)
  final double initialChildSize;
  
  /// Minimum child size (0.0 to 1.0)
  final double minChildSize;
  
  /// Maximum child size (0.0 to 1.0)
  final double maxChildSize;
  
  /// Whether to show close button
  final bool showCloseButton;
  
  /// Background color
  final Color? backgroundColor;

  const DraggableModal({
    super.key,
    this.title,
    required this.content,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.95,
    this.showCloseButton = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return BaseModal(
          title: title,
          content: content,
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
          isScrollable: false,
        );
      },
    );
  }

  /// Show as draggable modal
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.95,
    bool showCloseButton = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableModal(
        title: title,
        content: content,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        showCloseButton: showCloseButton,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

/// Alert dialog variant
class AlertModal extends StatelessWidget {
  /// Alert title
  final String title;
  
  /// Alert message
  final String message;
  
  /// Alert icon
  final IconData? icon;
  
  /// Icon color
  final Color? iconColor;
  
  /// Action buttons
  final List<Widget> actions;

  const AlertModal({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
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
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor ?? AppColors.primary,
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
      actions: actions,
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  /// Show as alert dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    required List<Widget> actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertModal(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        actions: actions,
      ),
    );
  }
}
