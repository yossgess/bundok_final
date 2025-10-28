import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';
import 'core/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BundokApp());
}

class BundokApp extends StatelessWidget {
  const BundokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bundok',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      
      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      
      // RTL Support - handled automatically by MaterialApp
      // The locale and Directionality are set automatically based on the locale
      
      home: const AppShell(),
    );
  }
}
