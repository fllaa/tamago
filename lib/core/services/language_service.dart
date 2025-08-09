import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String defaultLanguage = 'en';

  /// Get the saved language code from shared preferences
  Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? defaultLanguage;
  }

  /// Save the selected language code to shared preferences
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Get the locale based on the language code
  Locale getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'id':
        return const Locale('id');
      case 'en':
      default:
        return const Locale('en');
    }
  }
}
