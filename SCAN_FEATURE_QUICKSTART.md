# Scan Document Feature - Quick Start Guide

## 🚀 Quick Setup (5 minutes)

### Step 1: Install Dependencies
```bash
cd d:\finalfinal\bundok_final
flutter pub get
flutter gen-l10n
```

### Step 2: Add Native Permissions

#### Android
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these lines before <application> -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <application ...>
        ...
    </application>
</manifest>
```

#### iOS
Edit `ios/Runner/Info.plist`:
```xml
<dict>
    <!-- Add these entries -->
    <key>NSCameraUsageDescription</key>
    <string>Camera access is required to scan invoices.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Photo library access is required to upload invoices.</string>
    
    <!-- ... other entries ... -->
</dict>
```

### Step 3: Test Navigation

Add a test button to your main screen (e.g., in `lib/main.dart`):

```dart
import 'package:bundok_final/features/scan_document/presentation/scan_document_screen.dart';

// In your build method:
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanDocumentScreen(),
      ),
    );
  },
  child: const Text('Test Scan Document'),
)
```

### Step 4: Run on Physical Device
```bash
# Connect your device via USB

# Android
flutter run

# iOS (requires Mac)
flutter run
```

## 📱 Testing Workflow

### Test 1: Camera Scan
1. Launch app
2. Tap "Test Scan Document" button
3. Grant camera permission when prompted
4. Position a document (invoice, receipt, paper)
5. Tap the large blue capture button
6. Review the scanned image
7. Tap "Use This" to confirm

### Test 2: Gallery Upload
1. Launch scanner
2. Tap "Upload from Gallery" (bottom-left)
3. Grant photos permission when prompted
4. Select an image from gallery
5. Review the image
6. Tap "Use This" to confirm

### Test 3: Permission Denial
1. Launch scanner
2. Deny camera permission
3. Verify error state appears
4. Tap "Open Settings"
5. Enable camera permission
6. Return to app
7. Verify scanner works

### Test 4: RTL (Arabic)
1. Change device language to Arabic
2. Launch scanner
3. Verify UI is right-to-left
4. Verify all text is in Arabic
5. Test all functions

## 🎯 Expected Results

### ✅ Success Indicators
- Camera preview appears full-screen
- Document edges detected automatically (green outline)
- Flash toggle works (icon changes)
- Gallery picker opens
- Preview shows captured image
- Retake returns to scanner
- All text is localized
- No crashes on permission denial

### ❌ Common Issues

**Issue**: "Document scanning requires a physical device"  
**Fix**: You're on a simulator. Use a real device.

**Issue**: Camera permission always denied  
**Fix**: Check native permissions are added to AndroidManifest.xml / Info.plist

**Issue**: Localization keys not found  
**Fix**: Run `flutter gen-l10n`

**Issue**: flutter_doc_scanner not found  
**Fix**: Run `flutter pub get` and rebuild

## 📸 Screenshots to Capture

For documentation/testing:
1. Scanner screen with document positioned
2. Flash toggle active
3. Gallery upload button
4. Preview screen with scanned image
5. Permission denied error state
6. Arabic RTL layout

## 🔧 Integration with Your App

### Option 1: Add to FAB
```dart
floatingActionButton: ThemedFAB.camera(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanDocumentScreen(),
      ),
    );
  },
  tooltip: AppLocalizations.of(context)!.scanTitle,
),
```

### Option 2: Add to Dashboard
```dart
PrimaryButton(
  label: AppLocalizations.of(context)!.scanTitle,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanDocumentScreen(),
      ),
    );
  },
  leadingIcon: Icons.document_scanner,
)
```

### Option 3: Add to App Router (go_router)
```dart
GoRoute(
  path: '/scan',
  builder: (context, state) => const ScanDocumentScreen(),
),

// Navigate with:
context.go('/scan');
```

## 🎨 Customization Examples

### Change Capture Button Color
Edit `scan_controls.dart`:
```dart
Container(
  decoration: const BoxDecoration(
    color: AppColors.accent, // Change from primary to accent
    shape: BoxShape.circle,
  ),
  // ...
)
```

### Add Custom Processing
Edit `scan_preview_screen.dart`:
```dart
void _handleUseImage(BuildContext context) {
  // Add your OCR processing here
  final imageFile = capturedImage;
  
  // Example: Call OCR service
  // await OcrService.processInvoice(imageFile);
  
  // Navigate to review screen
  // Navigator.push(...);
}
```

### Customize Error Messages
Edit ARB files in `l10n/`:
```json
{
  "scanCameraPermissionDenied": "Your custom message here"
}
```

## 📊 Performance Tips

### Optimize Image Size
Add to `scan_preview_screen.dart`:
```dart
Image.file(
  capturedImage,
  fit: BoxFit.contain,
  cacheWidth: 1024, // Limit memory usage
  cacheHeight: 1024,
)
```

### Add Image Compression
```dart
import 'package:image/image.dart' as img;

final bytes = await capturedImage.readAsBytes();
final image = img.decodeImage(bytes);
final compressed = img.encodeJpg(image!, quality: 85);
```

## 🐛 Debug Mode

Add debug logging:
```dart
// In scan_document_screen.dart
void _handleScan() async {
  print('🎥 Starting scan...');
  // ... existing code
  print('✅ Scan completed: ${scannedImage?.path}');
}
```

## ✅ Verification Checklist

Before marking as complete:
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Localizations generated (`flutter gen-l10n`)
- [ ] Native permissions added (Android + iOS)
- [ ] Tested on physical device
- [ ] Camera scan works
- [ ] Gallery upload works
- [ ] Permission handling works
- [ ] Preview screen works
- [ ] Retake/confirm flow works
- [ ] All text is localized
- [ ] Arabic RTL works
- [ ] No hardcoded strings
- [ ] No hardcoded colors
- [ ] No crashes or errors

## 🎉 You're Done!

The Scan Document feature is now fully integrated and ready for production use. 

**Next Steps**:
1. Test thoroughly on physical devices
2. Integrate with your OCR service
3. Add navigation from dashboard/FAB
4. Implement invoice review screen
5. Add cloud upload functionality

**Questions?** Check the comprehensive README at:
`lib/features/scan_document/README.md`
