import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import 'ocr_processing_screen.dart';

/// Post-capture document preview screen
/// 
/// Features:
/// - Full-screen image preview of scanned/uploaded document
/// - Retake option to go back to scanner
/// - Confirm option to proceed with OCR processing
/// - RTL layout support
/// - Localized UI
class ScanPreviewScreen extends StatelessWidget {
  /// Captured/uploaded image file
  final File capturedImage;

  const ScanPreviewScreen({
    super.key,
    required this.capturedImage,
  });

  /// Handle retake action
  void _handleRetake(BuildContext context) {
    Navigator.pop(context);
  }

  /// Handle use/confirm action - navigate to OCR processing
  Future<void> _handleUseImage(BuildContext context) async {
    // Show immediate feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting OCR processing...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      if (kDebugMode) {
        debugPrint('[ScanPreview] 🚀 Button pressed - starting navigation');
        debugPrint('[ScanPreview] Image path: ${capturedImage.path}');
        debugPrint('[ScanPreview] Image exists: ${capturedImage.existsSync()}');
      }

      // Navigate to OCR processing screen
      final imageName = capturedImage.path.split(Platform.pathSeparator).last;
      
      if (kDebugMode) {
        debugPrint('[ScanPreview] Image name: $imageName');
        debugPrint('[ScanPreview] About to push OcrProcessingScreen...');
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (kDebugMode) {
              debugPrint('[ScanPreview] ✅ Building OcrProcessingScreen');
            }
            return OcrProcessingScreen(
              imageFile: capturedImage,
              imageName: imageName,
            );
          },
        ),
      );

      if (kDebugMode) {
        debugPrint('[ScanPreview] Navigation completed/returned');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[ScanPreview] ❌ Navigation error: $e');
        debugPrint('[ScanPreview] Stack trace: $stackTrace');
      }

      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: ThemedAppBar(
        title: l10n.scanPreviewTitle,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Image/PDF preview
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  capturedImage,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ThemedIcon(
                            Icons.error_outline,
                            size: IconSize.large,
                            color: AppColors.error,
                          ),
                          SizedBox(height: 16),
                          ThemedText(
                            'Failed to load image',
                            variant: TextVariant.bodyMedium,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Retake button
                  Expanded(
                    child: SecondaryButton(
                      label: l10n.scanRetake,
                      onPressed: () => _handleRetake(context),
                      leadingIcon: Icons.refresh,
                      fullWidth: true,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Use This button
                  Expanded(
                    child: PrimaryButton(
                      label: l10n.scanUseThis,
                      onPressed: () => _handleUseImage(context),
                      trailingIcon: Icons.check,
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
