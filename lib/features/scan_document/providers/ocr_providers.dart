import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/ocr_job.dart';
import '../data/repositories/ocr_repository.dart';

/// Provider for OCR repository instance
final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepository();
});

/// State for OCR upload and processing
@immutable
class OcrState {
  final bool isUploading;
  final bool isProcessing;
  final OcrJob? currentJob;
  final String? error;

  const OcrState({
    this.isUploading = false,
    this.isProcessing = false,
    this.currentJob,
    this.error,
  });

  OcrState copyWith({
    bool? isUploading,
    bool? isProcessing,
    OcrJob? currentJob,
    String? error,
  }) {
    return OcrState(
      isUploading: isUploading ?? this.isUploading,
      isProcessing: isProcessing ?? this.isProcessing,
      currentJob: currentJob ?? this.currentJob,
      error: error ?? this.error,
    );
  }

  /// Check if any operation is in progress
  bool get isBusy => isUploading || isProcessing;

  /// Check if job is completed successfully
  bool get isCompleted =>
      currentJob != null && currentJob!.status == OcrJobStatus.completed;

  /// Check if job failed
  bool get isFailed =>
      currentJob != null && currentJob!.status == OcrJobStatus.failed;
}

/// Notifier for managing OCR state
class OcrNotifier extends StateNotifier<OcrState> {
  final OcrRepository _repository;

  OcrNotifier(this._repository) : super(const OcrState());

  /// Upload image and create OCR job
  Future<void> uploadAndCreateJob({
    required File imageFile,
    String? imageName,
  }) async {
    if (state.isBusy) {
      if (kDebugMode) {
        debugPrint('[OcrNotifier] ⚠️ Already busy, ignoring request');
      }
      return;
    }

    try {
      state = state.copyWith(isUploading: true, error: null);

      if (kDebugMode) {
        debugPrint('[OcrNotifier] 📤 Starting upload and job creation');
      }

      final job = await _repository.uploadAndCreateJob(
        imageFile: imageFile,
        imageName: imageName,
      );

      state = state.copyWith(
        isUploading: false,
        currentJob: job,
      );

      if (kDebugMode) {
        debugPrint('[OcrNotifier] ✅ Job created: ${job.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OcrNotifier] ❌ Upload failed: $e');
      }

      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
    }
  }

  /// Start polling job status
  Future<void> startPolling(String jobId) async {
    if (state.isProcessing) {
      if (kDebugMode) {
        debugPrint('[OcrNotifier] ⚠️ Already polling');
      }
      return;
    }

    try {
      state = state.copyWith(isProcessing: true, error: null);

      if (kDebugMode) {
        debugPrint('[OcrNotifier] 🔄 Starting to poll job: $jobId');
      }

      await for (final job in _repository.pollJobStatus(jobId)) {
        state = state.copyWith(currentJob: job);

        if (kDebugMode) {
          debugPrint('[OcrNotifier] 📊 Job update: ${job.status.name}');
        }

        // Stop processing when job is done
        if (job.status == OcrJobStatus.completed ||
            job.status == OcrJobStatus.failed) {
          state = state.copyWith(isProcessing: false);

          if (job.status == OcrJobStatus.failed) {
            state = state.copyWith(error: job.error ?? 'OCR processing failed');
          }

          break;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OcrNotifier] ❌ Polling error: $e');
      }

      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  /// Reset state
  void reset() {
    if (kDebugMode) {
      debugPrint('[OcrNotifier] 🔄 Resetting state');
    }
    state = const OcrState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for OCR state management
final ocrProvider = StateNotifierProvider<OcrNotifier, OcrState>((ref) {
  final repository = ref.watch(ocrRepositoryProvider);
  return OcrNotifier(repository);
});
