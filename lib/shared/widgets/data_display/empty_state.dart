import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../buttons/primary_button.dart';

/// Empty state component for when no data exists
/// 
/// Features:
/// - Illustration (Lottie or asset) + title + subtitle
/// - Optional CTA button
/// - Used when no invoices exist
/// - Customizable styling
/// - Centered layout
class EmptyState extends StatelessWidget {
  /// Empty state icon
  final IconData? icon;
  
  /// Optional illustration widget (e.g., Lottie animation)
  final Widget? illustration;
  
  /// Title text
  final String title;
  
  /// Subtitle text
  final String? subtitle;
  
  /// Optional CTA button label
  final String? ctaLabel;
  
  /// Optional CTA button callback
  final VoidCallback? onCtaPressed;
  
  /// Optional CTA button icon
  final IconData? ctaIcon;
  
  /// Icon size
  final double iconSize;
  
  /// Icon color
  final Color? iconColor;
  
  /// Title text style
  final TextStyle? titleStyle;
  
  /// Subtitle text style
  final TextStyle? subtitleStyle;
  
  /// Padding around the content
  final EdgeInsetsGeometry? padding;

  const EmptyState({
    super.key,
    this.icon,
    this.illustration,
    required this.title,
    this.subtitle,
    this.ctaLabel,
    this.onCtaPressed,
    this.ctaIcon,
    this.iconSize = 80.0,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
  });

  /// Empty invoices state
  const EmptyState.noInvoices({
    super.key,
    this.illustration,
    this.ctaLabel = 'Add Invoice',
    this.onCtaPressed,
    this.padding,
  })  : icon = Icons.receipt_long_outlined,
        title = 'No Invoices Yet',
        subtitle = 'Start by scanning or creating your first invoice',
        ctaIcon = Icons.add,
        iconSize = 80.0,
        iconColor = null,
        titleStyle = null,
        subtitleStyle = null;

  /// Empty search results state
  const EmptyState.noResults({
    super.key,
    this.illustration,
    String? searchQuery,
    this.padding,
  })  : icon = Icons.search_off,
        title = 'No Results Found',
        subtitle = searchQuery != null
            ? 'No results found for "$searchQuery"'
            : 'Try adjusting your search criteria',
        ctaLabel = null,
        onCtaPressed = null,
        ctaIcon = null,
        iconSize = 80.0,
        iconColor = null,
        titleStyle = null,
        subtitleStyle = null;

  /// Empty chat history state
  const EmptyState.noChatHistory({
    super.key,
    this.illustration,
    this.ctaLabel = 'Start Chat',
    this.onCtaPressed,
    this.padding,
  })  : icon = Icons.chat_bubble_outline,
        title = 'No Chat History',
        subtitle = 'Ask questions about your invoices to get started',
        ctaIcon = Icons.send,
        iconSize = 80.0,
        iconColor = null,
        titleStyle = null,
        subtitleStyle = null;

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle = titleStyle ??
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        );
    
    final effectiveSubtitleStyle = subtitleStyle ??
        TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.6),
        );
    
    final effectiveIconColor = iconColor ?? AppColors.text.withOpacity(0.3);

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or Icon
            if (illustration != null)
              SizedBox(
                height: iconSize * 1.5,
                child: illustration,
              )
            else if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: effectiveIconColor,
              ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: effectiveTitleStyle,
              textAlign: TextAlign.center,
            ),
            
            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: effectiveSubtitleStyle,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
            
            // CTA Button
            if (ctaLabel != null && onCtaPressed != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: ctaLabel!,
                onPressed: onCtaPressed,
                leadingIcon: ctaIcon,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state component for failures
/// 
/// Features:
/// - Warning icon + message
/// - "Retry" button
/// - Used for OCR failures or network errors
/// - Customizable styling
class ErrorState extends StatelessWidget {
  /// Error icon
  final IconData? icon;
  
  /// Error title
  final String title;
  
  /// Error message
  final String? message;
  
  /// Retry button label
  final String retryLabel;
  
  /// Retry button callback
  final VoidCallback? onRetry;
  
  /// Optional secondary action label
  final String? secondaryActionLabel;
  
  /// Optional secondary action callback
  final VoidCallback? onSecondaryAction;
  
  /// Icon size
  final double iconSize;
  
  /// Icon color
  final Color? iconColor;
  
  /// Title text style
  final TextStyle? titleStyle;
  
  /// Message text style
  final TextStyle? messageStyle;
  
  /// Padding around the content
  final EdgeInsetsGeometry? padding;

  const ErrorState({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.retryLabel = 'Retry',
    this.onRetry,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.iconColor,
    this.titleStyle,
    this.messageStyle,
    this.padding,
  });

  /// OCR failure error state
  const ErrorState.ocrFailed({
    super.key,
    this.message = 'Unable to extract invoice data. Please try again or enter details manually.',
    this.onRetry,
    this.secondaryActionLabel = 'Enter Manually',
    this.onSecondaryAction,
    this.padding,
  })  : icon = Icons.document_scanner_outlined,
        title = 'OCR Processing Failed',
        retryLabel = 'Retry Scan',
        iconSize = 64.0,
        iconColor = AppColors.error,
        titleStyle = null,
        messageStyle = null;

  /// Network error state
  const ErrorState.networkError({
    super.key,
    this.message = 'Please check your internet connection and try again.',
    this.onRetry,
    this.padding,
  })  : icon = Icons.wifi_off,
        title = 'Connection Error',
        retryLabel = 'Retry',
        secondaryActionLabel = null,
        onSecondaryAction = null,
        iconSize = 64.0,
        iconColor = AppColors.error,
        titleStyle = null,
        messageStyle = null;

  /// Server error state
  const ErrorState.serverError({
    super.key,
    this.message = 'Something went wrong on our end. Please try again later.',
    this.onRetry,
    this.padding,
  })  : icon = Icons.cloud_off,
        title = 'Server Error',
        retryLabel = 'Retry',
        secondaryActionLabel = null,
        onSecondaryAction = null,
        iconSize = 64.0,
        iconColor = AppColors.error,
        titleStyle = null,
        messageStyle = null;

  /// Permission denied error state
  const ErrorState.permissionDenied({
    super.key,
    required String permissionType,
    this.onRetry,
    this.padding,
  })  : icon = Icons.block,
        title = 'Permission Required',
        message = 'Please grant $permissionType permission to continue.',
        retryLabel = 'Grant Permission',
        secondaryActionLabel = null,
        onSecondaryAction = null,
        iconSize = 64.0,
        iconColor = AppColors.warning,
        titleStyle = null,
        messageStyle = null;

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle = titleStyle ??
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        );
    
    final effectiveMessageStyle = messageStyle ??
        TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.7),
        );
    
    final effectiveIconColor = iconColor ?? AppColors.error;

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: iconSize,
                color: effectiveIconColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: effectiveTitleStyle,
              textAlign: TextAlign.center,
            ),
            
            // Message
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: effectiveMessageStyle,
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Retry Button
            if (onRetry != null)
              PrimaryButton(
                label: retryLabel,
                onPressed: onRetry,
                leadingIcon: Icons.refresh,
              ),
            
            // Secondary Action
            if (secondaryActionLabel != null && onSecondaryAction != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onSecondaryAction,
                child: Text(secondaryActionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state component
class LoadingState extends StatelessWidget {
  /// Loading message
  final String? message;
  
  /// Optional progress value (0.0 to 1.0)
  final double? progress;
  
  /// Message text style
  final TextStyle? messageStyle;
  
  /// Padding around the content
  final EdgeInsetsGeometry? padding;

  const LoadingState({
    super.key,
    this.message,
    this.progress,
    this.messageStyle,
    this.padding,
  });

  /// OCR processing loading state
  const LoadingState.processing({
    super.key,
    this.message = 'Processing invoice...',
    this.progress,
    this.padding,
  }) : messageStyle = null;

  /// Uploading loading state
  const LoadingState.uploading({
    super.key,
    this.message = 'Uploading...',
    this.progress,
    this.padding,
  }) : messageStyle = null;

  @override
  Widget build(BuildContext context) {
    final effectiveMessageStyle = messageStyle ??
        TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.7),
        );

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (progress != null)
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  backgroundColor: AppColors.border,
                ),
              )
            else
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: effectiveMessageStyle,
                textAlign: TextAlign.center,
              ),
            ],
            if (progress != null) ...[
              const SizedBox(height: 8),
              Text(
                '${(progress! * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success state component
class SuccessState extends StatelessWidget {
  /// Success title
  final String title;
  
  /// Success message
  final String? message;
  
  /// Optional CTA button label
  final String? ctaLabel;
  
  /// Optional CTA button callback
  final VoidCallback? onCtaPressed;
  
  /// Icon size
  final double iconSize;
  
  /// Padding around the content
  final EdgeInsetsGeometry? padding;

  const SuccessState({
    super.key,
    required this.title,
    this.message,
    this.ctaLabel,
    this.onCtaPressed,
    this.iconSize = 64.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: iconSize,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (ctaLabel != null && onCtaPressed != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: ctaLabel!,
                onPressed: onCtaPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
