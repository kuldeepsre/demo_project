
import 'package:flutter/cupertino.dart';

import 'LocalizationKeys.dart';



class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      LocalizationKeys.title: 'Day Night Mode Example',
      LocalizationKeys.welcomeMessage: 'Welcome to your app!',
      LocalizationKeys.toggleTheme: 'Toggle Theme',
      LocalizationKeys.toggleLanguage: 'Toggle Language',
    },
    'hi': {
      LocalizationKeys.title: 'डे नाइट मोड उदाहरण',
      LocalizationKeys.welcomeMessage: 'अपने ऐप्लिकेशन में आपका स्वागत है!',
      LocalizationKeys.toggleTheme: 'थीम बदलें',
      LocalizationKeys.toggleLanguage: 'भाषा बदलें',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? '';
  }
}
class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final Locale overriddenLocale;

  const AppLocalizationsDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(overriddenLocale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}