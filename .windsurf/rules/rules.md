---
trigger: always_on
---

File Generation Policy
Never generate .md, .txt, or documentation files unless explicitly requested.
Only produce executable code (.dart, .arb, .yaml, asset files).
Configuration files (e.g., pubspec.yaml, AndroidManifest.xml) may be updated only when necessary and with justification.
🎨 2. UI & Component Usage
Always reuse existing components from /lib/shared/widgets or feature-specific components.
❌ Never duplicate PrimaryButton, ThemedText, etc.
✅ If a component is missing, create it in the correct module first, then use it.
Never hardcode colors, spacing, or typography.
Use AppColors, Theme.of(context), or design tokens exclusively.
All new widgets must be const-constructible where possible.
🌐 3. Internationalization (i18n)
Every user-facing string must be localized.
❌ No hardcoded strings like "Scan Invoice"
✅ Use tr('scan.title') or AppLocalizations.of(context)!.scanTitle
Add new keys to all three ARB files:
l10n/app_en.arb
l10n/app_fr.arb
l10n/app_ar.arb
Keys must be semantic and grouped:
// ✅ Good
"scan.title": "Scan Invoice",
"scan.uploadGallery": "Upload from Gallery"

// ❌ Bad
"button1": "Click me"

4. Logging & Debugging
Add structured debug logs for critical flows (e.g., scanning, OCR, navigation):

debugPrint('[ScanDocument] Camera permission granted');
debugPrint('[ScanDocument] Captured image: ${file.path}');

Never log sensitive data:
❌ No invoice amounts, vendor names, or personal info
✅ Only metadata: "OCR started for invoice ID: inv_2025_1029"
Logs must be wrapped in kDebugMode in production-sensitive areas:
if (kDebugMode) debugPrint('...');
Code Structure & Architecture
Follow feature-first structure:
/lib/features/scan_document/
  /presentation   ← Screens & widgets
  /domain         ← (Future) Use cases, entities
  /data           ← (Future) Repositories, datasources

No cross-feature imports:
A feature may only import from /lib/core and /lib/shared.
Keep widgets small:
50 lines? Consider splitting into sub-widgets. 
Use Riverpod for state:
No setState in feature screens. Use ConsumerWidget + providers.
🧪 6. Testing & Reliability
All interactive elements must have Semantics or accessibilityLabel.
Support dynamic text scaling (test with 2.0x font size).
Handle errors gracefully:
Use try/catch around camera, file I/O, and network calls.
Show user-friendly messages (localized).
RTL must be tested:
Wrap previews in Directionality(textDirection: TextDirection.rtl) during dev.
🎯 7. Performance & Best Practices
Avoid unnecessary rebuilds:
Use const widgets, ProviderListener, and select() in Riverpod.
Compress images before processing (max 1500px width).
Dispose controllers:
Camera, animation, scroll controllers must be disposed.
Use late final for single-init values, not var.
🚫 8. Strictly Forbidden
❌ Hardcoded strings or colors
❌ Direct use of Colors.blue, Colors.white, etc.
❌ print() — use debugPrint()
❌ // TODO without ticket reference (use // TODO(INV-123): ...)
❌ Screens with business logic — keep presentation dumb
❌ Ignoring linter warnings (flutter_lints: ^4.0.0 is enforced)
🔁 9. Workflow Discipline
Before committing:
Run flutter analyze
Run flutter format .
Verify all 3 languages render correctly
Test on physical device (iOS + Android)
Branch naming: feature/scan-module, fix/camera-permission
PRs must include:
Screenshots (LTR + RTL)
List of new ARB keys added
