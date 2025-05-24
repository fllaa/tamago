import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> set(String key, dynamic value);
  Future<dynamic> get(String key);
  Future<bool> has(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPrefsStorageService implements StorageService {
  final SharedPreferences _prefs;

  SharedPrefsStorageService(this._prefs);

  @override
  Future<void> set(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // For complex objects, convert to JSON string
      await _prefs.setString(key, json.encode(value));
    }
  }

  @override
  Future<dynamic> get(String key) async {
    return _prefs.get(key);
  }

  /// Gets a value of type T
  Future<T?> getTyped<T>(String key) async {
    final value = await get(key);

    if (value == null) {
      return null;
    }

    if (T == String && value is String) {
      return value as T;
    } else if (T == int && value is int) {
      return value as T;
    } else if (T == double && value is double) {
      return value as T;
    } else if (T == bool && value is bool) {
      return value as T;
    } else if (value is List<String>) {
      return value as T;
    } else if (value is String) {
      // Try to decode JSON
      try {
        return json.decode(value) as T;
      } catch (e) {
        return value as T;
      }
    }

    return value as T;
  }

  @override
  Future<bool> has(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
