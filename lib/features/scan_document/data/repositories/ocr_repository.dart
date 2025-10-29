import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/ocr_job.dart';

/// Repository for managing OCR jobs and image uploads
/// 
/// Handles:
/// - Image upload to Supabase Storage
/// - OCR job creation in database
/// - Job status polling
/// - Result retrieval
class OcrRepository {
  final _supabase = SupabaseService.instance.client;
  final _uuid = const Uuid();

  /// Upload image to Supabase Storage and create OCR job
  /// 
  /// Returns the created [OcrJob] with pending status.
  /// The desktop worker will pick up this job and process it.
  Future<OcrJob> uploadAndCreateJob({
    required File imageFile,
    String? imageName,
  }) async {
    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = imageFile.path.split('.').last;
      final fileName = imageName ?? 'scan_$timestamp.$extension';
      final storagePath = '$timestamp\_$fileName';

      if (kDebugMode) {
        debugPrint('[OcrRepository] 📤 Uploading image: $fileName');
        debugPrint('[OcrRepository] Storage path: $storagePath');
      }

      // Read image bytes
      final imageBytes = await imageFile.readAsBytes();

      // Upload to Supabase Storage
      await _supabase.storage.from(SupabaseConfig.ocrImagesBucket).uploadBinary(
            storagePath,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      if (kDebugMode) {
        debugPrint('[OcrRepository] ✅ Image uploaded successfully');
      }

      // Get public URL
      final imageUrl = _supabase.storage
          .from(SupabaseConfig.ocrImagesBucket)
          .getPublicUrl(storagePath);

      if (kDebugMode) {
        debugPrint('[OcrRepository] 🔗 Public URL: $imageUrl');
        debugPrint('[OcrRepository] 🔗 URL Type: ${imageUrl.runtimeType}');
      }

      // Ensure imageUrl is a String
      final imageUrlString = imageUrl.toString();

      // Create OCR job in database
      final jobId = _uuid.v4();
      final now = DateTime.now();

      final jobData = {
        'id': jobId,
        'image_url': imageUrlString,
        'image_name': fileName,
        'status': 'pending',
        'created_at': now.toIso8601String(),
      };

      if (kDebugMode) {
        debugPrint('[OcrRepository] 📋 Creating OCR job: $jobId');
      }

      final response = await _supabase
          .from(SupabaseConfig.ocrJobsTable)
          .insert(jobData)
          .select()
          .single();

      final ocrJob = OcrJob.fromJson(response);

      if (kDebugMode) {
        debugPrint('[OcrRepository] ✅ OCR job created: ${ocrJob.id}');
      }

      return ocrJob;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OcrRepository] ❌ Error uploading and creating job: $e');
      }
      rethrow;
    }
  }

  /// Get OCR job by ID
  Future<OcrJob> getJob(String jobId) async {
    try {
      if (kDebugMode) {
        debugPrint('[OcrRepository] 🔍 Fetching job: $jobId');
      }

      final response = await _supabase
          .from(SupabaseConfig.ocrJobsTable)
          .select()
          .eq('id', jobId)
          .single();

      return OcrJob.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OcrRepository] ❌ Error fetching job: $e');
      }
      rethrow;
    }
  }

  /// Poll job status until completed or failed
  /// 
  /// Checks every [pollInterval] seconds (default: 3s)
  /// Returns a stream of job updates
  Stream<OcrJob> pollJobStatus(
    String jobId, {
    Duration pollInterval = const Duration(seconds: 3),
  }) async* {
    if (kDebugMode) {
      debugPrint('[OcrRepository] 🔄 Starting to poll job: $jobId');
    }

    while (true) {
      try {
        final job = await getJob(jobId);
        yield job;

        if (kDebugMode) {
          debugPrint('[OcrRepository] 📊 Job status: ${job.status.name}');
        }

        // Stop polling if job is completed or failed
        if (job.status == OcrJobStatus.completed ||
            job.status == OcrJobStatus.failed) {
          if (kDebugMode) {
            debugPrint('[OcrRepository] ✅ Job finished: ${job.status.name}');
          }
          break;
        }

        // Wait before next poll
        await Future.delayed(pollInterval);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[OcrRepository] ❌ Error polling job: $e');
        }
        rethrow;
      }
    }
  }

  /// Get all pending jobs (for debugging/monitoring)
  Future<List<OcrJob>> getPendingJobs() async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.ocrJobsTable)
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => OcrJob.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OcrRepository] ❌ Error fetching pending jobs: $e');
      }
      rethrow;
    }
  }

  /// Get recent jobs for user (optional: add user_id filter in future)
  Future<List<OcrJob>> getRecentJobs({int limit = 10}) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.ocrJobsTable)
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => OcrJob.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OcrRepository] ❌ Error fetching recent jobs: $e');
      }
      rethrow;
    }
  }
}
