import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../utils/scan_permissions.dart';
import '../widgets/scan_controls.dart';
import 'scan_preview_screen.dart';

/// Main document scanning screen
/// 
/// Features:
/// - Full-screen document scanner with automatic edge detection
/// - Flash toggle control
/// - Gallery upload fallback
/// - Permission handling with settings redirect
/// - RTL layout support
/// - Localized UI
class ScanDocumentScreen extends StatefulWidget {
  const ScanDocumentScreen({super.key});

  @override
  State<ScanDocumentScreen> createState() => _ScanDocumentScreenState();
}

class _ScanDocumentScreenState extends State<ScanDocumentScreen> {
  bool _isFlashOn = false;
  bool _isProcessing = false;
  bool _permissionDenied = false;
  bool _isPermanentlyDenied = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  /// Check camera permission on screen load
  Future<void> _checkPermissions() async {
    final hasPermission = await ScanPermissions.hasCameraPermission();
    
    if (!hasPermission) {
      final granted = await ScanPermissions.requestCameraPermission();
      
      if (!granted) {
        final isPermanent = await ScanPermissions.isCameraPermissionPermanentlyDenied();
        
        if (mounted) {
          setState(() {
            _permissionDenied = true;
            _isPermanentlyDenied = isPermanent;
          });
        }
      }
    }
  }

  /// Handle document scan using flutter_doc_scanner
  Future<void> _handleScan() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Check if running on physical device
      if (kIsWeb || Platform.isIOS && !await _isPhysicalDevice() || 
          Platform.isAndroid && !await _isPhysicalDevice()) {
        if (mounted) {
          _showDeviceRequiredMessage();
        }
        return;
      }

      // Launch document scanner
      final docScanner = FlutterDocScanner();
      final scannedImage = await docScanner.getScanDocuments();

      if (scannedImage != null && mounted) {
        // Navigate to preview screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanPreviewScreen(
              capturedImage: File(scannedImage),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showScanError();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Handle gallery upload
  Future<void> _handleGalleryUpload() async {
    if (_isProcessing) return;

    // Request photos permission
    final hasPermission = await ScanPermissions.requestPhotosPermission();
    
    if (!hasPermission) {
      if (mounted) {
        _showPermissionError('photos');
      }
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null && mounted) {
        // Navigate to preview screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanPreviewScreen(
              capturedImage: File(image.path),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showScanError();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Toggle flash on/off
  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    // Note: Flash control would be implemented via camera controller
    // flutter_doc_scanner handles this internally
  }

  /// Check if running on physical device
  Future<bool> _isPhysicalDevice() async {
    // Simple heuristic - in production, use device_info_plus
    return !kIsWeb;
  }

  /// Show device required message
  void _showDeviceRequiredMessage() {
    final l10n = AppLocalizations.of(context)!;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ThemedText(
          l10n.scanDeviceRequired,
          variant: TextVariant.bodyMedium,
          color: Colors.white,
        ),
        backgroundColor: AppColors.warning,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show scan error
  void _showScanError() {
    final l10n = AppLocalizations.of(context)!;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ThemedText(
          l10n.scanFailedMessage,
          variant: TextVariant.bodyMedium,
          color: Colors.white,
        ),
        backgroundColor: AppColors.error,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _handleScan,
        ),
      ),
    );
  }

  /// Show permission error
  void _showPermissionError(String permissionType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ThemedText(
          'Permission required to access $permissionType',
          variant: TextVariant.bodyMedium,
          color: Colors.white,
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  /// Open app settings
  Future<void> _openSettings() async {
    await ScanPermissions.openSettings();
    
    // Recheck permissions after returning from settings
    if (mounted) {
      await _checkPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: ThemedAppBar(
        title: l10n.scanTitle,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Main content
          if (_permissionDenied)
            _buildPermissionDeniedView(l10n)
          else
            _buildScannerView(l10n),
          
          // Loading overlay
          if (_isProcessing)
            ScanLoadingOverlay(
              message: l10n.scanProcessing,
            ),
        ],
      ),
    );
  }

  /// Build scanner view with controls
  Widget _buildScannerView(AppLocalizations l10n) {
    return Stack(
      children: [
        // Camera preview placeholder
        // Note: flutter_doc_scanner handles its own camera view
        Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ThemedIcon(
                  Icons.document_scanner,
                  size: IconSize.xLarge,
                  color: Colors.white54,
                  customSize: 80,
                ),
                const SizedBox(height: 16),
                ThemedText(
                  'Position document within frame',
                  variant: TextVariant.bodyMedium,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
        
        // Custom controls overlay
        ScanControls(
          onCapture: _handleScan,
          onGallery: _handleGalleryUpload,
          onFlashToggle: _toggleFlash,
          isFlashOn: _isFlashOn,
          galleryLabel: l10n.scanUploadGallery,
          flashTooltip: l10n.scanFlash,
          captureTooltip: l10n.scanCapture,
        ),
      ],
    );
  }

  /// Build permission denied view
  Widget _buildPermissionDeniedView(AppLocalizations l10n) {
    return ErrorState(
      icon: Icons.camera_alt_outlined,
      title: l10n.scanFailed,
      message: l10n.scanCameraPermissionDenied,
      retryLabel: _isPermanentlyDenied ? l10n.scanOpenSettings : 'Grant Permission',
      onRetry: _isPermanentlyDenied ? _openSettings : _checkPermissions,
      iconColor: AppColors.warning,
    );
  }
}
