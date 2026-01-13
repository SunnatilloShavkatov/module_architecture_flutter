import 'package:core/src/constants/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart' show Box;
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalSource {
  const LocalSource();

  bool get hasProfile;

  String? get locale;

  Future<void> setLocale(String locale);

  ThemeMode get themeMode;

  Future<void> setThemeMode(ThemeMode mode);

  String? get accessToken;

  Future<void> setAccessToken(String accessToken);

  String get firstName;

  Future<void> setFirstName(String firstName);

  Future<void> clear();
}

final class LocalSourceImpl implements LocalSource {
  const LocalSourceImpl(this._box, this._cacheBox, this._preferences);

  final Box<dynamic> _box;
  final Box<dynamic> _cacheBox;
  final SharedPreferencesWithCache _preferences;

  @override
  bool get hasProfile => accessToken != null;

  @override
  Future<void> setLocale(String locale) async {
    await _preferences.setString(StorageKeys.locale, locale);
  }

  @override
  String? get locale => _preferences.getString(StorageKeys.locale);

  @override
  ThemeMode get themeMode => switch (_preferences.getString(StorageKeys.themeMode)) {
    'system' => ThemeMode.system,
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setString(StorageKeys.themeMode, mode.name);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _preferences.setString(StorageKeys.accessToken, accessToken);
  }

  @override
  String? get accessToken => _preferences.getString(StorageKeys.accessToken);

  @override
  Future<void> setFirstName(String firstName) async {
    await _box.put(StorageKeys.firstname, firstName);
  }

  @override
  String get firstName => _box.get(StorageKeys.firstname, defaultValue: '');

  @override
  Future<void> clear() async {
    await Future.wait([
      _preferences.remove(StorageKeys.hasProfile),
      _preferences.remove(StorageKeys.accessToken),
      _box.clear(),
      _cacheBox.clear(),
    ]);
  }
}
