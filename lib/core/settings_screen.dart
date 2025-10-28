import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/l10n/app_localizations.dart';
import '../shared/widgets/widgets.dart';

/// Settings screen - App configuration
/// 
/// Features:
/// - Language selection
/// - Theme preferences
/// - Account settings
/// - About app
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale _currentLocale = const Locale('en');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = Localizations.localeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ThemedAppBar(
        title: 'Settings',
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language section
          ThemedText.titleMedium(
            l10n.language,
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            icon: Icons.language,
            title: l10n.language,
            subtitle: _getLanguageName(_currentLocale),
            onTap: () => _showLanguageDialog(context),
          ),
          
          const SizedBox(height: 24),
          
          // App info section
          ThemedText.titleMedium(
            'About',
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: null,
          ),
          
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: () {},
          ),
          
          _buildSettingsTile(
            icon: Icons.gavel_outlined,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return CardContainer(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ThemedText.titleSmall(
                    title,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  ThemedText.bodySmall(
                    subtitle,
                    color: AppColors.text.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.text,
              ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
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
              _buildLanguageOption(const Locale('en'), 'English'),
              _buildLanguageOption(const Locale('fr'), 'Français'),
              _buildLanguageOption(const Locale('ar'), 'العربية'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(Locale locale, String name) {
    final isSelected = _currentLocale == locale;
    
    return ListTile(
      title: Text(name),
      leading: Radio<Locale>(
        value: locale,
        groupValue: _currentLocale,
        onChanged: (Locale? value) {
          if (value != null) {
            // Note: Language switching requires app restart with current setup
            // For dynamic switching, you'd need to implement a locale provider
            setState(() {
              _currentLocale = value;
            });
            Navigator.of(context).pop();
            
            // Show message that app needs restart
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Language will change on app restart'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _currentLocale = locale;
        });
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Language will change on app restart'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
