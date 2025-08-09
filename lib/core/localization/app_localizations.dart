import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to access localized strings
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static method to get the delegate
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Map to store localized values
  late Map<String, String> _localizedStrings;

  // Load the language JSON file
  Future<bool> load() async {
    // Load the language JSON file
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    // Parse the JSON
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = {};
    jsonMap.forEach((key, value) {
      _localizedStrings[key] = value.toString();
    });

    return true;
  }

  // Get localized string
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all supported languages here
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
