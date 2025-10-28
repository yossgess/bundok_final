import 'package:permission_handler/permission_handler.dart';

/// Utility class for handling scan-related permissions
/// 
/// Manages camera and photo library permissions required for
/// document scanning and gallery upload functionality.
class ScanPermissions {
  ScanPermissions._();

  /// Request camera permission for document scanning
  /// 
  /// Returns true if permission is granted, false otherwise.
  /// Handles both initial request and checking existing permission status.
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
    
    // Permission is permanently denied or restricted
    return false;
  }

  /// Request photo library permission for gallery upload
  /// 
  /// Returns true if permission is granted, false otherwise.
  /// On iOS 14+, this requests limited or full photo library access.
  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.status;
    
    if (status.isGranted || status.isLimited) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.photos.request();
      return result.isGranted || result.isLimited;
    }
    
    // Permission is permanently denied or restricted
    return false;
  }

  /// Check if camera permission is granted
  /// 
  /// Returns true if camera access is available.
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if photos permission is granted
  /// 
  /// Returns true if photo library access is available.
  /// On iOS, limited access also returns true.
  static Future<bool> hasPhotosPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted || status.isLimited;
  }

  /// Check if camera permission is permanently denied
  /// 
  /// Returns true if user has permanently denied camera access.
  /// In this case, we should direct them to app settings.
  static Future<bool> isCameraPermissionPermanentlyDenied() async {
    final status = await Permission.camera.status;
    return status.isPermanentlyDenied;
  }

  /// Check if photos permission is permanently denied
  /// 
  /// Returns true if user has permanently denied photo library access.
  static Future<bool> isPhotosPermissionPermanentlyDenied() async {
    final status = await Permission.photos.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings
  /// 
  /// Directs user to system settings where they can manually
  /// grant permissions if they were previously denied.
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
