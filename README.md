# Bundok - AI-Powered Invoice Management

Production-grade Flutter application for invoice management with OCR and RAG capabilities.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK: `>=3.24.0 <4.0.0`
- Dart SDK: `>=3.5.0 <4.0.0`
- Physical iOS/Android device or emulator

### Installation

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate localization files:**
   ```bash
   flutter gen-l10n
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/                   # App-wide infrastructure
│   ├── constants/          # Colors, routes
│   ├── theme/              # Material 3 theme
│   ├── l10n/               # Generated localization files
│   ├── routes/             # GoRouter configuration
│   └── utils/              # Extensions, helpers
├── features/               # Feature modules
│   ├── dashboard/          # Dashboard feature
│   ├── invoices/           # Invoice management
│   ├── scan_document/      # OCR scanning
│   └── chat/               # RAG-based chat
├── shared/                 # Reusable components
│   ├── widgets/            # Themed UI components
│   └── components/         # Composed widgets
└── main.dart               # App entry point
```

## 🎨 Theme

Uses **Clash Display** color palette with Material 3:
- **Primary:** `#7BBBFF` (Light Blue)
- **Secondary:** `#050F2A` (Deep Navy)
- **Accent:** `#B8A9FF` (Lavender)
- **Background:** `#FFFFFF` (White)
- **Border:** `#F2FDFF` (Off-White)

All colors meet WCAG AA accessibility standards.

## 🌐 Internationalization

Supports 3 languages with full RTL support:
- **English** (en)
- **French** (fr)
- **Arabic** (ar) - with RTL layout

Change language via the language icon in the app bar.

## 🔧 Tech Stack

- **Framework:** Flutter 3.24+
- **State Management:** Riverpod 2.5
- **Navigation:** GoRouter 14.0
- **Localization:** flutter_localizations + easy_localization
- **HTTP Client:** Dio 5.7
- **Camera:** camera 0.10.7
- **Image Picker:** image_picker 1.1.2
- **Permissions:** permission_handler 11.3.1

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (11.0+)

## 🔐 Permissions

### Android
- `CAMERA` - Document scanning
- `READ_MEDIA_IMAGES` - Gallery access
- `INTERNET` - API calls

### iOS
- `NSCameraUsageDescription` - Document scanning
- `NSPhotoLibraryUsageDescription` - Gallery access

## 📝 Development Guidelines

### Feature-First Architecture
- Each feature is self-contained in `/features`
- No cross-feature imports
- Features depend only on `/core` and `/shared`

### Code Style
- Follow `flutter_lints` rules
- Use Material 3 components
- Maintain WCAG AA contrast ratios

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🏗️ Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📄 License

Proprietary - All rights reserved

## 👥 Team

Built for production-scale invoice management with AI capabilities.
