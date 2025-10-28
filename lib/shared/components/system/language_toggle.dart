import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../modals/language_selector_modal.dart';

/// Language toggle button component
/// 
/// Features:
/// - Button that opens LanguageSelectorModal
/// - Shows current language code (e.g., "EN")
/// - Optional flag display
/// - Customizable styling
class LanguageToggle extends StatelessWidget {
  /// Currently selected language
  final Language selectedLanguage;
  
  /// List of available languages
  final List<Language> languages;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageChanged;
  
  /// Whether to show flag
  final bool showFlag;
  
  /// Whether to show language name
  final bool showName;
  
  /// Button style
  final LanguageToggleStyle style;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Text color
  final Color? textColor;
  
  /// Border color
  final Color? borderColor;

  const LanguageToggle({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageChanged,
    this.showFlag = true,
    this.showName = false,
    this.style = LanguageToggleStyle.outlined,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  /// Compact toggle (code only)
  const LanguageToggle.compact({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageChanged,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  })  : showFlag = false,
        showName = false,
        style = LanguageToggleStyle.outlined;

  /// Icon toggle (flag only)
  const LanguageToggle.icon({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageChanged,
    this.backgroundColor,
    this.textColor,
  })  : showFlag = true,
        showName = false,
        style = LanguageToggleStyle.filled,
        borderColor = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showLanguageSelector(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: _getDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flag
            if (showFlag && selectedLanguage.flag != null) ...[
              Text(
                selectedLanguage.flag!,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 6),
            ],
            
            // Language code or name
            Text(
              showName 
                  ? selectedLanguage.nativeName 
                  : selectedLanguage.code.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor ?? _getTextColor(),
              ),
            ),
            
            const SizedBox(width: 4),
            
            // Dropdown icon
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: textColor ?? _getTextColor(),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (style) {
      case LanguageToggleStyle.filled:
        return BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        );
      
      case LanguageToggleStyle.outlined:
        return BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor ?? AppColors.border,
            width: 1.5,
          ),
        );
      
      case LanguageToggleStyle.text:
        return BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        );
    }
  }

  Color _getTextColor() {
    switch (style) {
      case LanguageToggleStyle.filled:
        return AppColors.primary;
      case LanguageToggleStyle.outlined:
      case LanguageToggleStyle.text:
        return AppColors.secondary;
    }
  }

  Future<void> _showLanguageSelector(BuildContext context) async {
    final selected = await LanguageSelectorModal.show(
      context: context,
      languages: languages,
      selectedLanguageCode: selectedLanguage.code,
    );
    
    if (selected != null && onLanguageChanged != null) {
      onLanguageChanged!(selected);
    }
  }
}

/// Language toggle style variants
enum LanguageToggleStyle {
  filled,
  outlined,
  text,
}

/// App bar language toggle
class AppBarLanguageToggle extends StatelessWidget {
  /// Currently selected language
  final Language selectedLanguage;
  
  /// List of available languages
  final List<Language> languages;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageChanged;

  const AppBarLanguageToggle({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showLanguageSelector(context),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedLanguage.flag != null)
            Text(
              selectedLanguage.flag!,
              style: const TextStyle(fontSize: 18),
            )
          else
            const Icon(Icons.language, size: 20),
          const SizedBox(width: 4),
          Text(
            selectedLanguage.code.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
      tooltip: 'Change Language',
    );
  }

  Future<void> _showLanguageSelector(BuildContext context) async {
    final selected = await LanguageSelectorModal.show(
      context: context,
      languages: languages,
      selectedLanguageCode: selectedLanguage.code,
    );
    
    if (selected != null && onLanguageChanged != null) {
      onLanguageChanged!(selected);
    }
  }
}

/// Floating language toggle button
class FloatingLanguageToggle extends StatelessWidget {
  /// Currently selected language
  final Language selectedLanguage;
  
  /// List of available languages
  final List<Language> languages;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageChanged;
  
  /// Position from bottom
  final double bottom;
  
  /// Position from right
  final double right;

  const FloatingLanguageToggle({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageChanged,
    this.bottom = 16.0,
    this.right = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => _showLanguageSelector(context),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedLanguage.flag != null)
                  Text(
                    selectedLanguage.flag!,
                    style: const TextStyle(fontSize: 20),
                  )
                else
                  const Icon(Icons.language, size: 20, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  selectedLanguage.code.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageSelector(BuildContext context) async {
    final selected = await LanguageSelectorModal.show(
      context: context,
      languages: languages,
      selectedLanguageCode: selectedLanguage.code,
    );
    
    if (selected != null && onLanguageChanged != null) {
      onLanguageChanged!(selected);
    }
  }
}

/// Language menu item for drawer/settings
class LanguageMenuItem extends StatelessWidget {
  /// Currently selected language
  final Language selectedLanguage;
  
  /// List of available languages
  final List<Language> languages;
  
  /// Callback when language is selected
  final ValueChanged<Language>? onLanguageChanged;
  
  /// Menu item title
  final String title;
  
  /// Whether to show leading icon
  final bool showIcon;

  const LanguageMenuItem({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    this.onLanguageChanged,
    this.title = 'Language',
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: showIcon
          ? Container(
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
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
        ),
      ),
      subtitle: Text(
        selectedLanguage.nativeName,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.6),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedLanguage.flag != null)
            Text(
              selectedLanguage.flag!,
              style: const TextStyle(fontSize: 20),
            ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: AppColors.secondary,
          ),
        ],
      ),
      onTap: () => _showLanguageSelector(context),
    );
  }

  Future<void> _showLanguageSelector(BuildContext context) async {
    final selected = await LanguageSelectorModal.show(
      context: context,
      languages: languages,
      selectedLanguageCode: selectedLanguage.code,
    );
    
    if (selected != null && onLanguageChanged != null) {
      onLanguageChanged!(selected);
    }
  }
}
