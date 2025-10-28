import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/material.dart' as material show TextButton;
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';

/// Custom controls overlay for document scanner
/// 
/// Provides capture button, flash toggle, and gallery upload option
/// positioned over the camera preview with themed styling.
class ScanControls extends StatelessWidget {
  /// Callback when capture button is pressed
  final VoidCallback onCapture;
  
  /// Callback when gallery button is pressed
  final VoidCallback onGallery;
  
  /// Callback when flash toggle is pressed
  final VoidCallback onFlashToggle;
  
  /// Whether flash is currently enabled
  final bool isFlashOn;
  
  /// Gallery button label (localized)
  final String galleryLabel;
  
  /// Flash button tooltip (localized)
  final String flashTooltip;
  
  /// Capture button tooltip (localized)
  final String captureTooltip;

  const ScanControls({
    super.key,
    required this.onCapture,
    required this.onGallery,
    required this.onFlashToggle,
    required this.isFlashOn,
    required this.galleryLabel,
    required this.flashTooltip,
    required this.captureTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar with flash toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Flash toggle button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: ThemedIconButton(
                    icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                    onPressed: onFlashToggle,
                    tooltip: flashTooltip,
                    color: isFlashOn ? AppColors.primary : Colors.white,
                    size: IconSize.medium,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Bottom controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gallery upload button (left)
                Expanded(
                  child: material.TextButton.icon(
                    onPressed: onGallery,
                    icon: const ThemedIcon(
                      Icons.photo_library,
                      size: IconSize.small,
                      color: Colors.white,
                    ),
                    label: ThemedText(
                      galleryLabel,
                      variant: TextVariant.bodySmall,
                      color: Colors.white,
                    ),
                    style: material.TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Capture button (center)
                GestureDetector(
                  onTap: onCapture,
                  child: Semantics(
                    label: captureTooltip,
                    button: true,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Spacer to balance layout
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple loading overlay for scan processing
class ScanLoadingOverlay extends StatelessWidget {
  /// Loading message (localized)
  final String message;

  const ScanLoadingOverlay({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            ThemedText(
              message,
              variant: TextVariant.bodyMedium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
