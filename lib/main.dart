import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      path: 'l10n',
      fallbackLocale: const Locale('en'),
      child: const BundokApp(),
    ),
  );
}

class BundokApp extends StatelessWidget {
  const BundokApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final isRTL = locale.languageCode == 'ar';

    return MaterialApp(
      title: 'Bundok',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      
      // Localization
      locale: locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: [
        ...context.localizationDelegates,
        AppLocalizations.delegate,
      ],
      
      // RTL Support
      builder: (context, child) {
        if (isRTL) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        }
        return child!;
      },
      
      home: const EnvironmentReadyScreen(),
    );
  }
}

class EnvironmentReadyScreen extends StatelessWidget {
  const EnvironmentReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
            tooltip: AppLocalizations.of(context)!.language,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.environmentReady,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildLanguageInfo(context),
            const SizedBox(height: 24),
            _buildThemePreview(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageInfo(BuildContext context) {
    final locale = context.locale;
    final languageName = {
      'en': 'English',
      'fr': 'Français',
      'ar': 'العربية',
    }[locale.languageCode] ?? locale.languageCode;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${AppLocalizations.of(context)!.language}: $languageName',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Text Direction: ${Directionality.of(context).name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreview(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Theme Preview',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, const Locale('en'), 'English'),
              _buildLanguageOption(context, const Locale('fr'), 'Français'),
              _buildLanguageOption(context, const Locale('ar'), 'العربية'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, Locale locale, String name) {
    final isSelected = context.locale == locale;
    
    return ListTile(
      title: Text(name),
      leading: Radio<Locale>(
        value: locale,
        groupValue: context.locale,
        onChanged: (Locale? value) {
          if (value != null) {
            context.setLocale(value);
            Navigator.of(context).pop();
          }
        },
      ),
      selected: isSelected,
      onTap: () {
        context.setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }
}
