import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Document preview component for displaying processed invoice images
/// 
/// Features:
/// - Shows processed invoice image
/// - Border and shadow styling
/// - Optional "Retake" overlay
/// - Zoom and pan capabilities
/// - Loading state support
/// - Error handling
class DocumentPreview extends StatelessWidget {
  /// Image source (File, network URL, or asset path)
  final dynamic imageSource;
  
  /// Image source type
  final ImageSourceType sourceType;
  
  /// Optional height constraint
  final double? height;
  
  /// Optional width constraint
  final double? width;
  
  /// Whether to show retake overlay
  final bool showRetakeOverlay;
  
  /// Callback when retake is pressed
  final VoidCallback? onRetake;
  
  /// Callback when image is tapped
  final VoidCallback? onTap;
  
  /// Border radius
  final double borderRadius;
  
  /// Whether to enable zoom/pan
  final bool enableZoom;
  
  /// Fit mode for the image
  final BoxFit fit;
  
  /// Optional placeholder widget
  final Widget? placeholder;
  
  /// Optional error widget
  final Widget? errorWidget;

  const DocumentPreview({
    super.key,
    required this.imageSource,
    required this.sourceType,
    this.height,
    this.width,
    this.showRetakeOverlay = false,
    this.onRetake,
    this.onTap,
    this.borderRadius = 12.0,
    this.enableZoom = false,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  /// Preview from file
  const DocumentPreview.file({
    super.key,
    required File file,
    this.height,
    this.width,
    this.showRetakeOverlay = false,
    this.onRetake,
    this.onTap,
    this.borderRadius = 12.0,
    this.enableZoom = false,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  })  : imageSource = file,
        sourceType = ImageSourceType.file;

  /// Preview from network URL
  const DocumentPreview.network({
    super.key,
    required String url,
    this.height,
    this.width,
    this.showRetakeOverlay = false,
    this.onRetake,
    this.onTap,
    this.borderRadius = 12.0,
    this.enableZoom = false,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  })  : imageSource = url,
        sourceType = ImageSourceType.network;

  /// Preview from asset
  const DocumentPreview.asset({
    super.key,
    required String assetPath,
    this.height,
    this.width,
    this.showRetakeOverlay = false,
    this.onRetake,
    this.onTap,
    this.borderRadius = 12.0,
    this.enableZoom = false,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  })  : imageSource = assetPath,
        sourceType = ImageSourceType.asset;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImage();
    
    if (enableZoom) {
      imageWidget = InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        child: imageWidget,
      );
    }

    Widget preview = GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.border.withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColors.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: imageWidget,
      ),
    );

    // Add retake overlay if enabled
    if (showRetakeOverlay && onRetake != null) {
      preview = Stack(
        children: [
          preview,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: onRetake,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.secondary,
                      ),
                      child: const Text('Retake'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return preview;
  }

  Widget _buildImage() {
    final defaultPlaceholder = placeholder ??
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        );
    
    final defaultErrorWidget = errorWidget ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.broken_image,
                size: 48,
                color: AppColors.text.withOpacity(0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load image',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );

    switch (sourceType) {
      case ImageSourceType.file:
        return Image.file(
          imageSource as File,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
        );
      
      case ImageSourceType.network:
        return Image.network(
          imageSource as String,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return defaultPlaceholder;
          },
          errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
        );
      
      case ImageSourceType.asset:
        return Image.asset(
          imageSource as String,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
        );
    }
  }
}

/// Image source type enum
enum ImageSourceType {
  file,
  network,
  asset,
}

/// Document thumbnail for grid/list views
class DocumentThumbnail extends StatelessWidget {
  /// Image source
  final dynamic imageSource;
  
  /// Image source type
  final ImageSourceType sourceType;
  
  /// Thumbnail size
  final double size;
  
  /// Callback when tapped
  final VoidCallback? onTap;
  
  /// Optional badge (e.g., page number)
  final String? badge;
  
  /// Whether thumbnail is selected
  final bool selected;

  const DocumentThumbnail({
    super.key,
    required this.imageSource,
    required this.sourceType,
    this.size = 80.0,
    this.onTap,
    this.badge,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildThumbnailImage(),
          ),
          if (badge != null)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (selected)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnailImage() {
    switch (sourceType) {
      case ImageSourceType.file:
        return Image.file(
          imageSource as File,
          fit: BoxFit.cover,
        );
      case ImageSourceType.network:
        return Image.network(
          imageSource as String,
          fit: BoxFit.cover,
        );
      case ImageSourceType.asset:
        return Image.asset(
          imageSource as String,
          fit: BoxFit.cover,
        );
    }
  }
}

/// Document gallery for multiple pages/images
class DocumentGallery extends StatelessWidget {
  /// List of image sources
  final List<dynamic> imageSources;
  
  /// Image source type
  final ImageSourceType sourceType;
  
  /// Currently selected index
  final int selectedIndex;
  
  /// Callback when image is selected
  final ValueChanged<int>? onImageSelected;
  
  /// Thumbnail size
  final double thumbnailSize;
  
  /// Spacing between thumbnails
  final double spacing;

  const DocumentGallery({
    super.key,
    required this.imageSources,
    required this.sourceType,
    this.selectedIndex = 0,
    this.onImageSelected,
    this.thumbnailSize = 80.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thumbnailSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: imageSources.length,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return DocumentThumbnail(
            imageSource: imageSources[index],
            sourceType: sourceType,
            size: thumbnailSize,
            badge: '${index + 1}',
            selected: index == selectedIndex,
            onTap: onImageSelected != null
                ? () => onImageSelected!(index)
                : null,
          );
        },
      ),
    );
  }
}

/// Full-screen document viewer
class FullScreenDocumentViewer extends StatelessWidget {
  /// Image source
  final dynamic imageSource;
  
  /// Image source type
  final ImageSourceType sourceType;
  
  /// Optional title
  final String? title;
  
  /// Optional actions
  final List<Widget>? actions;

  const FullScreenDocumentViewer({
    super.key,
    required this.imageSource,
    required this.sourceType,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: title != null ? Text(title!) : null,
        actions: actions,
      ),
      body: InteractiveViewer(
        minScale: 1.0,
        maxScale: 5.0,
        child: Center(
          child: DocumentPreview(
            imageSource: imageSource,
            sourceType: sourceType,
            enableZoom: false, // InteractiveViewer handles zoom
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
