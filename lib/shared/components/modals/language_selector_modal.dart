import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'base_modal.dart';

/// Language selector modal component
/// 
/// Features:
/// - List: English / Français / العربية
/// - Checkmark on selected language
/// - Triggers RTL when Arabic is selected
/// - Customizable language list
class LanguageSelectorModal extends StatelessWidget {
  /// List of available languages
  final List<Language> languages;
  
  /// Currently selected language code
  final String selectedLanguageCode;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageSelected;
  
  /// Modal title
  final String title;

  const LanguageSelectorModal({
    super.key,
    required this.languages,
    required this.selectedLanguageCode,
    this.onLanguageSelected,
    this.title = 'Select Language',
  });

  /// Default language selector with English, French, Arabic
  factory LanguageSelectorModal.defaultLanguages({
    required String selectedLanguageCode,
    ValueChanged<Language>? onLanguageSelected,
    String title = 'Select Language',
  }) {
    return LanguageSelectorModal(
      languages: Language.defaultLanguages(),
      selectedLanguageCode: selectedLanguageCode,
      onLanguageSelected: onLanguageSelected,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: title,
      isScrollable: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: languages.map((language) {
          final isSelected = language.code == selectedLanguageCode;
          
          return InkWell(
            onTap: () {
              Navigator.of(context).pop(language);
              onLanguageSelected?.call(language);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Flag or icon
                  if (language.flag != null)
                    Text(
                      language.flag!,
                      style: const TextStyle(fontSize: 24),
                    )
                  else if (language.icon != null)
                    Icon(
                      language.icon,
                      size: 24,
                      color: AppColors.secondary,
                    ),
                  
                  const SizedBox(width: 16),
                  
                  // Language name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          language.nativeName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            color: AppColors.secondary,
                          ),
                        ),
                        if (language.englishName != language.nativeName)
                          Text(
                            language.englishName,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.text.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Checkmark
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Show language selector modal
  static Future<Language?> show({
    required BuildContext context,
    required List<Language> languages,
    required String selectedLanguageCode,
    ValueChanged<Language>? onLanguageSelected,
    String title = 'Select Language',
  }) {
    return showModalBottomSheet<Language>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguageSelectorModal(
        languages: languages,
        selectedLanguageCode: selectedLanguageCode,
        onLanguageSelected: onLanguageSelected,
        title: title,
      ),
    );
  }

  /// Show default language selector
  static Future<Language?> showDefault({
    required BuildContext context,
    required String selectedLanguageCode,
    ValueChanged<Language>? onLanguageSelected,
    String title = 'Select Language',
  }) {
    return show(
      context: context,
      languages: Language.defaultLanguages(),
      selectedLanguageCode: selectedLanguageCode,
      onLanguageSelected: onLanguageSelected,
      title: title,
    );
  }
}

/// Language data model
class Language {
  /// Language code (e.g., 'en', 'fr', 'ar')
  final String code;
  
  /// Native language name (e.g., 'English', 'Français', 'العربية')
  final String nativeName;
  
  /// English language name
  final String englishName;
  
  /// Whether language is RTL
  final bool isRTL;
  
  /// Optional flag emoji
  final String? flag;
  
  /// Optional icon
  final IconData? icon;

  const Language({
    required this.code,
    required this.nativeName,
    required this.englishName,
    this.isRTL = false,
    this.flag,
    this.icon,
  });

  /// Default supported languages
  static List<Language> defaultLanguages() => [
        const Language(
          code: 'en',
          nativeName: 'English',
          englishName: 'English',
          isRTL: false,
          flag: '🇬🇧',
        ),
        const Language(
          code: 'fr',
          nativeName: 'Français',
          englishName: 'French',
          isRTL: false,
          flag: '🇫🇷',
        ),
        const Language(
          code: 'ar',
          nativeName: 'العربية',
          englishName: 'Arabic',
          isRTL: true,
          flag: '🇸🇦',
        ),
      ];

  /// Extended language list
  static List<Language> extendedLanguages() => [
        ...defaultLanguages(),
        const Language(
          code: 'es',
          nativeName: 'Español',
          englishName: 'Spanish',
          isRTL: false,
          flag: '🇪🇸',
        ),
        const Language(
          code: 'de',
          nativeName: 'Deutsch',
          englishName: 'German',
          isRTL: false,
          flag: '🇩🇪',
        ),
        const Language(
          code: 'it',
          nativeName: 'Italiano',
          englishName: 'Italian',
          isRTL: false,
          flag: '🇮🇹',
        ),
        const Language(
          code: 'pt',
          nativeName: 'Português',
          englishName: 'Portuguese',
          isRTL: false,
          flag: '🇵🇹',
        ),
        const Language(
          code: 'ru',
          nativeName: 'Русский',
          englishName: 'Russian',
          isRTL: false,
          flag: '🇷🇺',
        ),
        const Language(
          code: 'zh',
          nativeName: '中文',
          englishName: 'Chinese',
          isRTL: false,
          flag: '🇨🇳',
        ),
        const Language(
          code: 'ja',
          nativeName: '日本語',
          englishName: 'Japanese',
          isRTL: false,
          flag: '🇯🇵',
        ),
      ];
}

/// Compact language selector (dropdown style)
class CompactLanguageSelector extends StatelessWidget {
  /// Currently selected language
  final Language selectedLanguage;
  
  /// List of available languages
  final List<Language> languages;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageSelected;

  const CompactLanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selected = await LanguageSelectorModal.show(
          context: context,
          languages: languages,
          selectedLanguageCode: selectedLanguage.code,
          onLanguageSelected: onLanguageSelected,
        );
        
        if (selected != null && onLanguageSelected != null) {
          onLanguageSelected!(selected);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedLanguage.flag != null)
              Text(
                selectedLanguage.flag!,
                style: const TextStyle(fontSize: 20),
              ),
            const SizedBox(width: 8),
            Text(
              selectedLanguage.nativeName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Language settings tile
class LanguageSettingsTile extends StatelessWidget {
  /// Currently selected language
  final Language selectedLanguage;
  
  /// List of available languages
  final List<Language> languages;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageSelected;
  
  /// Tile title
  final String title;
  
  /// Optional subtitle
  final String? subtitle;

  const LanguageSettingsTile({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageSelected,
    this.title = 'Language',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.language,
          color: AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
        ),
      ),
      subtitle: Text(
        subtitle ?? selectedLanguage.nativeName,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.6),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.secondary,
      ),
      onTap: () async {
        final selected = await LanguageSelectorModal.show(
          context: context,
          languages: languages,
          selectedLanguageCode: selectedLanguage.code,
          onLanguageSelected: onLanguageSelected,
        );
        
        if (selected != null && onLanguageSelected != null) {
          onLanguageSelected!(selected);
        }
      },
    );
  }
}
