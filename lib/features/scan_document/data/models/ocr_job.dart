import 'package:flutter/foundation.dart';

/// OCR job status enum
enum OcrJobStatus {
  pending,
  processing,
  completed,
  failed;

  /// Convert from string
  static OcrJobStatus fromString(String status) {
    return OcrJobStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OcrJobStatus.pending,
    );
  }

  /// Convert to string
  String toJson() => name;
}

/// OCR Job model matching Supabase schema
@immutable
class OcrJob {
  final String id;
  final String imageUrl;
  final String? imageName;
  final OcrJobStatus status;
  final String? result;
  final String? error;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const OcrJob({
    required this.id,
    required this.imageUrl,
    this.imageName,
    required this.status,
    this.result,
    this.error,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  /// Create from JSON (Supabase response)
  factory OcrJob.fromJson(Map<String, dynamic> json) {
    return OcrJob(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      imageName: json['image_name'] as String?,
      status: OcrJobStatus.fromString(json['status'] as String? ?? 'pending'),
      result: json['result'] as String?,
      error: json['error'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  /// Convert to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'image_name': imageName,
      'status': status.toJson(),
      'result': result,
      'error': error,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Copy with method for immutable updates
  OcrJob copyWith({
    String? id,
    String? imageUrl,
    String? imageName,
    OcrJobStatus? status,
    String? result,
    String? error,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return OcrJob(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      imageName: imageName ?? this.imageName,
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OcrJob &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.imageName == imageName &&
        other.status == status &&
        other.result == result &&
        other.error == error &&
        other.createdAt == createdAt &&
        other.startedAt == startedAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      imageUrl,
      imageName,
      status,
      result,
      error,
      createdAt,
      startedAt,
      completedAt,
    );
  }

  @override
  String toString() {
    return 'OcrJob(id: $id, status: $status, imageName: $imageName)';
  }
}
