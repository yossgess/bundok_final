import 'package:flutter/material.dart';

/// RTL Provider component
/// 
/// Features:
/// - Top-level widget that sets TextDirection based on locale
/// - Wraps entire app in MaterialApp.builder
/// - Manages RTL/LTR switching
/// - Persists text direction preference
class RTLProvider extends InheritedWidget {
  /// Current text direction
  final TextDirection textDirection;
  
  /// Callback to change text direction
  final ValueChanged<TextDirection>? onDirectionChanged;

  const RTLProvider({
    super.key,
    required this.textDirection,
    this.onDirectionChanged,
    required super.child,
  });

  /// Get RTL provider from context
  static RTLProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RTLProvider>();
  }

  /// Check if current direction is RTL
  static bool isRTL(BuildContext context) {
    final provider = of(context);
    return provider?.textDirection == TextDirection.rtl;
  }

  /// Get text direction from context
  static TextDirection getDirection(BuildContext context) {
    final provider = of(context);
    return provider?.textDirection ?? TextDirection.ltr;
  }

  @override
  bool updateShouldNotify(RTLProvider oldWidget) {
    return textDirection != oldWidget.textDirection;
  }
}

/// Stateful RTL provider with state management
class RTLProviderWidget extends StatefulWidget {
  /// Child widget
  final Widget child;
  
  /// Initial text direction
  final TextDirection initialDirection;
  
  /// Callback when direction changes
  final ValueChanged<TextDirection>? onDirectionChanged;

  const RTLProviderWidget({
    super.key,
    required this.child,
    this.initialDirection = TextDirection.ltr,
    this.onDirectionChanged,
  });

  @override
  State<RTLProviderWidget> createState() => RTLProviderWidgetState();
}

class RTLProviderWidgetState extends State<RTLProviderWidget> {
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    _textDirection = widget.initialDirection;
  }

  /// Update text direction
  void setTextDirection(TextDirection direction) {
    if (_textDirection != direction) {
      setState(() {
        _textDirection = direction;
      });
      widget.onDirectionChanged?.call(direction);
    }
  }

  /// Toggle between LTR and RTL
  void toggleDirection() {
    setTextDirection(
      _textDirection == TextDirection.ltr 
          ? TextDirection.rtl 
          : TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RTLProvider(
      textDirection: _textDirection,
      onDirectionChanged: setTextDirection,
      child: widget.child,
    );
  }
}

/// Directional wrapper that respects RTL
class DirectionalWrapper extends StatelessWidget {
  /// Child widget
  final Widget child;
  
  /// Text direction (if null, uses inherited direction)
  final TextDirection? textDirection;

  const DirectionalWrapper({
    super.key,
    required this.child,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final direction = textDirection ?? RTLProvider.getDirection(context);
    
    return Directionality(
      textDirection: direction,
      child: child,
    );
  }
}

/// RTL-aware padding
class RTLPadding extends StatelessWidget {
  /// Child widget
  final Widget child;
  
  /// Start padding (left in LTR, right in RTL)
  final double start;
  
  /// End padding (right in LTR, left in RTL)
  final double end;
  
  /// Top padding
  final double top;
  
  /// Bottom padding
  final double bottom;

  const RTLPadding({
    super.key,
    required this.child,
    this.start = 0,
    this.end = 0,
    this.top = 0,
    this.bottom = 0,
  });

  /// Symmetric padding
  const RTLPadding.symmetric({
    super.key,
    required this.child,
    double horizontal = 0,
    double vertical = 0,
  })  : start = horizontal,
        end = horizontal,
        top = vertical,
        bottom = vertical;

  /// All sides padding
  const RTLPadding.all({
    super.key,
    required this.child,
    required double value,
  })  : start = value,
        end = value,
        top = value,
        bottom = value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}

/// RTL-aware alignment
class RTLAlign extends StatelessWidget {
  /// Child widget
  final Widget child;
  
  /// Alignment (start = left in LTR, right in RTL)
  final AlignmentDirectional alignment;

  const RTLAlign({
    super.key,
    required this.child,
    this.alignment = AlignmentDirectional.centerStart,
  });

  /// Start alignment
  const RTLAlign.start({
    super.key,
    required this.child,
  }) : alignment = AlignmentDirectional.centerStart;

  /// End alignment
  const RTLAlign.end({
    super.key,
    required this.child,
  }) : alignment = AlignmentDirectional.centerEnd;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}

/// Helper extension for RTL-aware operations
extension RTLExtension on BuildContext {
  /// Check if current direction is RTL
  bool get isRTL => RTLProvider.isRTL(this);
  
  /// Get current text direction
  TextDirection get textDirection => RTLProvider.getDirection(this);
  
  /// Get start alignment (left in LTR, right in RTL)
  Alignment get alignmentStart => 
      isRTL ? Alignment.centerRight : Alignment.centerLeft;
  
  /// Get end alignment (right in LTR, left in RTL)
  Alignment get alignmentEnd => 
      isRTL ? Alignment.centerLeft : Alignment.centerRight;
}

/// MaterialApp wrapper with RTL support
class RTLMaterialApp extends StatelessWidget {
  /// App title
  final String title;
  
  /// Theme data
  final ThemeData? theme;
  
  /// Dark theme data
  final ThemeData? darkTheme;
  
  /// Theme mode
  final ThemeMode themeMode;
  
  /// Home widget
  final Widget? home;
  
  /// Routes
  final Map<String, WidgetBuilder>? routes;
  
  /// Initial route
  final String? initialRoute;
  
  /// Locale
  final Locale? locale;
  
  /// Supported locales
  final List<Locale> supportedLocales;
  
  /// Localization delegates
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  
  /// Text direction
  final TextDirection textDirection;
  
  /// Callback when direction changes
  final ValueChanged<TextDirection>? onDirectionChanged;

  const RTLMaterialApp({
    super.key,
    required this.title,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.home,
    this.routes,
    this.initialRoute,
    this.locale,
    this.supportedLocales = const [Locale('en')],
    this.localizationsDelegates,
    this.textDirection = TextDirection.ltr,
    this.onDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RTLProviderWidget(
      initialDirection: textDirection,
      onDirectionChanged: onDirectionChanged,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: title,
            theme: theme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: home,
            routes: routes ?? {},
            initialRoute: initialRoute,
            locale: locale,
            supportedLocales: supportedLocales,
            localizationsDelegates: localizationsDelegates,
            builder: (context, child) {
              return Directionality(
                textDirection: RTLProvider.getDirection(context),
                child: child ?? const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }
}

/// Language-based text direction helper
class LanguageDirection {
  /// Get text direction for language code
  static TextDirection fromLanguageCode(String languageCode) {
    final rtlLanguages = ['ar', 'he', 'fa', 'ur', 'yi'];
    return rtlLanguages.contains(languageCode.toLowerCase())
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  /// Check if language is RTL
  static bool isRTLLanguage(String languageCode) {
    return fromLanguageCode(languageCode) == TextDirection.rtl;
  }

  /// Get locale from language code
  static Locale getLocale(String languageCode) {
    return Locale(languageCode);
  }
}
