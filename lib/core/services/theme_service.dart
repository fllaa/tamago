import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_constants.dart';
import 'package:flutter_boilerplate/core/services/storage_service.dart';

class ThemeService {
  final SharedPrefsStorageService _storageService;

  ThemeService(this._storageService);

  /// Get the current theme mode from storage
  Future<ThemeMode> getThemeMode() async {
    final themeString = await _storageService.getTyped<String>(AppConstants.themeKey);
    
    if (themeString == null) {
      return ThemeMode.system;
    }
    
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Save the theme mode to storage
  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeString = 'system';
        break;
    }
    
    await _storageService.set(AppConstants.themeKey, themeString);
  }
}
