import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// AI thinking indicator component
/// 
/// Features:
/// - Animated bouncing dots
/// - Localized text ("Searching your invoices…")
/// - Multiple animation styles
/// - Customizable colors and text
class AiThinkingIndicator extends StatefulWidget {
  /// Status text
  final String text;
  
  /// Animation style
  final ThinkingAnimationStyle style;
  
  /// Dot color
  final Color? dotColor;
  
  /// Text color
  final Color? textColor;
  
  /// Whether to show avatar
  final bool showAvatar;
  
  /// Padding around the indicator
  final EdgeInsetsGeometry? padding;

  const AiThinkingIndicator({
    super.key,
    this.text = 'Searching your invoices…',
    this.style = ThinkingAnimationStyle.bounce,
    this.dotColor,
    this.textColor,
    this.showAvatar = true,
    this.padding,
  });

  /// Searching indicator
  const AiThinkingIndicator.searching({
    super.key,
    this.style = ThinkingAnimationStyle.bounce,
    this.dotColor,
    this.textColor,
    this.showAvatar = true,
    this.padding,
  }) : text = 'Searching your invoices…';

  /// Processing indicator
  const AiThinkingIndicator.processing({
    super.key,
    this.style = ThinkingAnimationStyle.bounce,
    this.dotColor,
    this.textColor,
    this.showAvatar = true,
    this.padding,
  }) : text = 'Processing your request…';

  /// Analyzing indicator
  const AiThinkingIndicator.analyzing({
    super.key,
    this.style = ThinkingAnimationStyle.bounce,
    this.dotColor,
    this.textColor,
    this.showAvatar = true,
    this.padding,
  }) : text = 'Analyzing data…';

  @override
  State<AiThinkingIndicator> createState() => _AiThinkingIndicatorState();
}

class _AiThinkingIndicatorState extends State<AiThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDotColor = widget.dotColor ?? AppColors.primary;
    final effectiveTextColor = widget.textColor ?? 
        AppColors.text.withOpacity(0.7);

    return Padding(
      padding: widget.padding ?? 
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          if (widget.showAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 18,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          // Animation
          _buildAnimation(effectiveDotColor),
          
          const SizedBox(width: 12),
          
          // Text
          Flexible(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 14,
                color: effectiveTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimation(Color color) {
    switch (widget.style) {
      case ThinkingAnimationStyle.bounce:
        return _BouncingDots(
          controller: _controller,
          color: color,
        );
      case ThinkingAnimationStyle.pulse:
        return _PulsingDots(
          controller: _controller,
          color: color,
        );
      case ThinkingAnimationStyle.wave:
        return _WaveDots(
          controller: _controller,
          color: color,
        );
      case ThinkingAnimationStyle.spinner:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
    }
  }
}

/// Thinking animation style
enum ThinkingAnimationStyle {
  bounce,
  pulse,
  wave,
  spinner,
}

/// Bouncing dots animation
class _BouncingDots extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _BouncingDots({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (controller.value - delay) % 1.0;
            final offset = (value < 0.5 ? value * 2 : (1 - value) * 2) * 8;
            
            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
              child: Transform.translate(
                offset: Offset(0, -offset),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Pulsing dots animation
class _PulsingDots extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _PulsingDots({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (controller.value - delay) % 1.0;
            final scale = (value < 0.5 ? value * 2 : (1 - value) * 2)
                .clamp(0.5, 1.0);
            
            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Wave dots animation
class _WaveDots extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _WaveDots({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final delay = index * 0.15;
            final value = (controller.value - delay) % 1.0;
            final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2)
                .clamp(0.3, 1.0);
            
            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color.withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Compact thinking indicator (inline)
class CompactThinkingIndicator extends StatelessWidget {
  /// Status text
  final String? text;
  
  /// Dot color
  final Color? dotColor;

  const CompactThinkingIndicator({
    super.key,
    this.text,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return AiThinkingIndicator(
      text: text ?? 'Thinking…',
      showAvatar: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dotColor: dotColor,
    );
  }
}

/// Full-screen thinking overlay
class ThinkingOverlay extends StatelessWidget {
  /// Status text
  final String text;
  
  /// Animation style
  final ThinkingAnimationStyle style;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Whether overlay is dismissible
  final bool dismissible;
  
  /// Callback when overlay is dismissed
  final VoidCallback? onDismiss;

  const ThinkingOverlay({
    super.key,
    this.text = 'Processing…',
    this.style = ThinkingAnimationStyle.spinner,
    this.backgroundColor,
    this.dismissible = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissible ? onDismiss : null,
      child: Container(
        color: backgroundColor ?? Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AiThinkingIndicator(
                  text: text,
                  style: style,
                  showAvatar: false,
                ),
                if (dismissible) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onDismiss,
                    child: const Text('Cancel'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Progress thinking indicator with percentage
class ProgressThinkingIndicator extends StatelessWidget {
  /// Status text
  final String text;
  
  /// Progress value (0.0 to 1.0)
  final double progress;
  
  /// Whether to show percentage
  final bool showPercentage;
  
  /// Progress color
  final Color? progressColor;
  
  /// Background color
  final Color? backgroundColor;

  const ProgressThinkingIndicator({
    super.key,
    required this.text,
    required this.progress,
    this.showPercentage = true,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgressColor = progressColor ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? 
        AppColors.border.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.text.withOpacity(0.7),
                  ),
                ),
              ),
              if (showPercentage)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: effectiveBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step-by-step thinking indicator
class StepThinkingIndicator extends StatelessWidget {
  /// Current step
  final int currentStep;
  
  /// Total steps
  final int totalSteps;
  
  /// Step descriptions
  final List<String> steps;
  
  /// Completed step color
  final Color? completedColor;
  
  /// Current step color
  final Color? currentColor;
  
  /// Pending step color
  final Color? pendingColor;

  const StepThinkingIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
    this.completedColor,
    this.currentColor,
    this.pendingColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCompletedColor = completedColor ?? AppColors.success;
    final effectiveCurrentColor = currentColor ?? AppColors.primary;
    final effectivePendingColor = pendingColor ?? 
        AppColors.text.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          final isPending = index > currentStep;
          
          Color color;
          IconData icon;
          
          if (isCompleted) {
            color = effectiveCompletedColor;
            icon = Icons.check_circle;
          } else if (isCurrent) {
            color = effectiveCurrentColor;
            icon = Icons.radio_button_checked;
          } else {
            color = effectivePendingColor;
            icon = Icons.radio_button_unchecked;
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < steps.length - 1 ? 12 : 0,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                      color: isPending 
                          ? AppColors.text.withOpacity(0.5) 
                          : AppColors.text,
                    ),
                  ),
                ),
                if (isCurrent)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
