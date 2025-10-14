import 'package:flutter/widgets.dart';
import 'package:keyper/l10n/gen/app_localizations.dart';

export 'package:keyper/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// Define a model to represent a supported language
// with its Locale and display name.
class SupportedLanguage {
  const SupportedLanguage({required this.locale, required this.name});
  final Locale locale;
  final String name;
}

// Centralized mapping of language codes to human-readable names.
// Extend this map when new locales are added to the project.
const Map<String, String> kSupportedLanguageNames = {
  'en': 'English',
  'hi': 'हिंदी',
};

// Returns SupportedLanguage entries for the locales 
// declared by AppLocalizations.
List<SupportedLanguage> getSupportedLanguages() {
  return AppLocalizations.supportedLocales
      .map(
        (l) => SupportedLanguage(
          locale: l,
          name: kSupportedLanguageNames[l.languageCode] ?? l.toLanguageTag(),
        ),
      )
      .toList();
}

// Convenience getters from BuildContext for supported locales and languages.
extension SupportedLocalesX on BuildContext {
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
  List<SupportedLanguage> get supportedLanguages => getSupportedLanguages();
}
