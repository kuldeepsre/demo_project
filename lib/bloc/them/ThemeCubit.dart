import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(_lightTheme));

  static final ThemeData _lightTheme = ThemeData.light();
  static final ThemeData _darkTheme = ThemeData.dark();

  void toggleTheme() {
    final newTheme =
    state.themeData == _lightTheme ? _darkTheme : _lightTheme;
    emit(ThemeState(newTheme));
  }
}

class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState(const Locale('en')));

  void toggleLanguage() {
    final newLocale =
    state.locale.languageCode == 'en' ? const Locale('hi') : const Locale('en');
    emit(LanguageState(newLocale));
  }
}

class LanguageState {
  final Locale locale;

  LanguageState(this.locale);
}
