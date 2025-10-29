import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/models/ocr_job.dart';
import '../providers/ocr_providers.dart';

/// OCR Processing screen with real-time status updates
/// 
/// Features:
/// - Real-time job status polling
/// - Visual progress indicators
/// - Success/failure handling
/// - OCR result display
/// - Navigation to invoice review
class OcrProcessingScreen extends ConsumerStatefulWidget {
  final File imageFile;
  final String? imageName;

  const OcrProcessingScreen({
    super.key,
    required this.imageFile,
    this.imageName,
  });

  @override
  ConsumerState<OcrProcessingScreen> createState() =>
      _OcrProcessingScreenState();
}

class _OcrProcessingScreenState extends ConsumerState<OcrProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // Start upload and processing immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startOcrProcess();
    });
  }

  /// Start the OCR process: upload image and poll for results
  Future<void> _startOcrProcess() async {
    try {
      if (kDebugMode) {
        debugPrint('[OcrProcessing] Starting OCR process');
        debugPrint('[OcrProcessing] Image: ${widget.imageFile.path}');
        debugPrint('[OcrProcessing] Image exists: ${widget.imageFile.existsSync()}');
      }

      final notifier = ref.read(ocrProvider.notifier);

      // Upload and create job
      await notifier.uploadAndCreateJob(
        imageFile: widget.imageFile,
        imageName: widget.imageName,
      );

      // Get the created job ID
      final state = ref.read(ocrProvider);
      if (state.currentJob != null) {
        if (kDebugMode) {
          debugPrint('[OcrProcessing] Job created: ${state.currentJob!.id}');
        }
        // Start polling for results
        await notifier.startPolling(state.currentJob!.id);
      } else {
        if (kDebugMode) {
          debugPrint('[OcrProcessing] ❌ No job created');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[OcrProcessing] ❌ Error in OCR process: $e');
        debugPrint('[OcrProcessing] Stack trace: $stackTrace');
      }
      // Error will be handled by the provider state
    }
  }

  /// Handle retry after failure
  void _handleRetry() {
    ref.read(ocrProvider.notifier).reset();
    _startOcrProcess();
  }

  /// Navigate back to scan screen
  void _handleCancel() {
    ref.read(ocrProvider.notifier).reset();
    Navigator.pop(context);
  }

  /// Handle successful OCR completion - no auto navigation
  void _handleSuccess(OcrJob job) {
    // Don't auto-navigate, let user review results
    if (kDebugMode) {
      debugPrint('[OcrProcessing] ✅ OCR completed, showing results');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ocrState = ref.watch(ocrProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ThemedAppBar(
        title: l10n.ocrProcessingTitle,
        leading: ocrState.isBusy
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: _handleCancel,
              ),
      ),
      body: SafeArea(
        child: _buildBody(l10n, ocrState),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, OcrState state) {
    // Error state
    if (state.error != null && !state.isBusy) {
      return _buildErrorView(l10n, state.error!);
    }

    // Success state
    if (state.isCompleted) {
      _handleSuccess(state.currentJob!);
      return _buildSuccessView(l10n, state.currentJob!);
    }

    // Failed state
    if (state.isFailed) {
      return _buildFailedView(l10n, state.currentJob!);
    }

    // Processing state
    return _buildProcessingView(l10n, state);
  }

  /// Build processing view with status updates
  Widget _buildProcessingView(AppLocalizations l10n, OcrState state) {
    String statusMessage;
    IconData statusIcon;
    Color statusColor;

    if (state.isUploading) {
      statusMessage = l10n.ocrUploading;
      statusIcon = Icons.cloud_upload;
      statusColor = AppColors.primary;
    } else if (state.currentJob?.status == OcrJobStatus.pending) {
      statusMessage = l10n.ocrWaitingWorker;
      statusIcon = Icons.hourglass_empty;
      statusColor = AppColors.warning;
    } else if (state.currentJob?.status == OcrJobStatus.processing) {
      statusMessage = l10n.ocrProcessingDocument;
      statusIcon = Icons.auto_awesome;
      statusColor = AppColors.primary;
    } else {
      statusMessage = l10n.ocrInitializing;
      statusIcon = Icons.sync;
      statusColor = AppColors.secondary;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Opacity(
                    opacity: 0.5 + (value * 0.5),
                    child: child,
                  ),
                );
              },
              child: ThemedIcon(
                statusIcon,
                size: IconSize.xLarge,
                color: statusColor,
                customSize: 80,
              ),
            ),

            const SizedBox(height: 32),

            // Status message
            ThemedText(
              statusMessage,
              variant: TextVariant.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Progress indicator
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),

            const SizedBox(height: 32),

            // Additional info
            if (state.currentJob != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      l10n.ocrJobId,
                      state.currentJob!.id.substring(0, 8),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      l10n.ocrStatus,
                      _getStatusLabel(l10n, state.currentJob!.status),
                    ),
                    if (state.currentJob!.imageName != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        l10n.ocrImageName,
                        state.currentJob!.imageName!,
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Helper text
            ThemedText(
              l10n.ocrWorkerInfo,
              variant: TextVariant.bodySmall,
              color: AppColors.secondary.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build success view
  Widget _buildSuccessView(AppLocalizations l10n, OcrJob job) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ThemedIcon(
                    Icons.check_circle,
                    size: IconSize.xLarge,
                    color: AppColors.success,
                    customSize: 80,
                  ),
                  const SizedBox(height: 24),
                  ThemedText(
                    l10n.ocrSuccess,
                    variant: TextVariant.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (job.result != null) ...[
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: SingleChildScrollView(
                        child: ThemedText(
                          job.result!,
                          variant: TextVariant.bodySmall,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Done button
        Padding(
          padding: const EdgeInsets.all(24),
          child: PrimaryButton(
            label: 'Done',
            onPressed: () {
              ref.read(ocrProvider.notifier).reset();
              // Pop twice to go back to home screen (skip preview screen)
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            fullWidth: true,
          ),
        ),
      ],
    );
  }

  /// Build failed view
  Widget _buildFailedView(AppLocalizations l10n, OcrJob job) {
    return ErrorState(
      icon: Icons.error_outline,
      title: l10n.ocrFailed,
      message: job.error ?? l10n.ocrFailedMessage,
      retryLabel: l10n.ocrRetry,
      onRetry: _handleRetry,
      iconColor: AppColors.error,
    );
  }

  /// Build error view
  Widget _buildErrorView(AppLocalizations l10n, String error) {
    return ErrorState(
      icon: Icons.cloud_off,
      title: l10n.ocrUploadFailed,
      message: error,
      retryLabel: l10n.ocrRetry,
      onRetry: _handleRetry,
      iconColor: AppColors.error,
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ThemedText(
          label,
          variant: TextVariant.bodySmall,
          color: AppColors.secondary.withOpacity(0.6),
        ),
        Flexible(
          child: ThemedText(
            value,
            variant: TextVariant.bodySmall,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Get localized status label
  String _getStatusLabel(AppLocalizations l10n, OcrJobStatus status) {
    switch (status) {
      case OcrJobStatus.pending:
        return l10n.ocrStatusPending;
      case OcrJobStatus.processing:
        return l10n.ocrStatusProcessing;
      case OcrJobStatus.completed:
        return l10n.ocrStatusCompleted;
      case OcrJobStatus.failed:
        return l10n.ocrStatusFailed;
    }
  }
}
