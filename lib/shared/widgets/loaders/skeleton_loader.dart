import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Skeleton loader with animated shimmer effect
/// 
/// Features:
/// - Animated shimmer for loading states
/// - Variants: text, rectangle, circle
/// - Used during OCR/chat loading states
/// - Customizable size and shape
/// - Smooth animation for better UX
class SkeletonLoader extends StatefulWidget {
  /// Width of the skeleton
  final double? width;
  
  /// Height of the skeleton
  final double height;
  
  /// Border radius for rounded corners
  final double borderRadius;
  
  /// Shape variant
  final SkeletonShape shape;
  
  /// Base color (light)
  final Color? baseColor;
  
  /// Highlight color (shimmer)
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 4.0,
    this.shape = SkeletonShape.rectangle,
    this.baseColor,
    this.highlightColor,
  });

  /// Text skeleton loader
  const SkeletonLoader.text({
    super.key,
    this.width,
    double fontSize = 14.0,
    this.baseColor,
    this.highlightColor,
  })  : height = fontSize,
        borderRadius = 2.0,
        shape = SkeletonShape.rectangle;

  /// Rectangle skeleton loader
  const SkeletonLoader.rectangle({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor,
    this.highlightColor,
  }) : shape = SkeletonShape.rectangle;

  /// Circle skeleton loader
  const SkeletonLoader.circle({
    super.key,
    required double size,
    this.baseColor,
    this.highlightColor,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = SkeletonShape.circle;

  /// Avatar skeleton loader (circular)
  const SkeletonLoader.avatar({
    super.key,
    double size = 40.0,
    this.baseColor,
    this.highlightColor,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = SkeletonShape.circle;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = widget.baseColor ?? 
        AppColors.border.withOpacity(0.3);
    final effectiveHighlightColor = widget.highlightColor ?? 
        AppColors.border.withOpacity(0.6);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.shape == SkeletonShape.circle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.shape == SkeletonShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                effectiveBaseColor,
                effectiveHighlightColor,
                effectiveBaseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton shape variants
enum SkeletonShape {
  rectangle,
  circle,
}

/// Skeleton paragraph - multiple text lines
class SkeletonParagraph extends StatelessWidget {
  /// Number of lines
  final int lines;
  
  /// Line height
  final double lineHeight;
  
  /// Spacing between lines
  final double lineSpacing;
  
  /// Optional width for each line (null for full width)
  final List<double?>? lineWidths;
  
  /// Base color
  final Color? baseColor;
  
  /// Highlight color
  final Color? highlightColor;

  const SkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight = 14.0,
    this.lineSpacing = 8.0,
    this.lineWidths,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        final width = lineWidths != null && index < lineWidths!.length
            ? lineWidths![index]
            : (isLastLine ? null : double.infinity);
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLastLine ? 0 : lineSpacing,
          ),
          child: SkeletonLoader.text(
            width: width ?? (isLastLine ? 200 : null),
            fontSize: lineHeight,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
        );
      }),
    );
  }
}

/// Skeleton card - common card loading pattern
class SkeletonCard extends StatelessWidget {
  /// Card height
  final double height;
  
  /// Whether to show avatar
  final bool showAvatar;
  
  /// Whether to show title
  final bool showTitle;
  
  /// Number of body lines
  final int bodyLines;
  
  /// Base color
  final Color? baseColor;
  
  /// Highlight color
  final Color? highlightColor;

  const SkeletonCard({
    super.key,
    this.height = 120.0,
    this.showAvatar = true,
    this.showTitle = true,
    this.bodyLines = 2,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            SkeletonLoader.avatar(
              size: 48,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTitle) ...[
                  SkeletonLoader.text(
                    width: 150,
                    fontSize: 16,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  const SizedBox(height: 8),
                ],
                SkeletonParagraph(
                  lines: bodyLines,
                  lineHeight: 12,
                  lineSpacing: 6,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton list - multiple skeleton items
class SkeletonList extends StatelessWidget {
  /// Number of items
  final int itemCount;
  
  /// Item height
  final double itemHeight;
  
  /// Spacing between items
  final double itemSpacing;
  
  /// Base color
  final Color? baseColor;
  
  /// Highlight color
  final Color? highlightColor;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.itemSpacing = 12.0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
      itemBuilder: (context, index) {
        return SkeletonCard(
          height: itemHeight,
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
      },
    );
  }
}
