import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

final class LocalSource {
  const LocalSource(this._box, this._cacheBox, this._preferences);

  final Box<dynamic> _box;
  final Box<dynamic> _cacheBox;
  final SharedPreferencesWithCache _preferences;

  bool get hasProfile => accessToken != null;

  Future<void> setHasProfile({required bool value}) async {
    await _preferences.setBool(AppKeys.hasProfile, value);
  }

  Future<void> setLocale(String locale) async {
    await _preferences.setString(AppKeys.locale, locale);
  }

  String? get locale => _preferences.getString(AppKeys.locale);

  ThemeMode get themeMode => switch (_preferences.getString(AppKeys.themeMode)) {
    'system' => ThemeMode.system,
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setString(AppKeys.themeMode, mode.name);
  }

  Future<void> setAccessToken(String accessToken) async {
    await _preferences.setString(AppKeys.accessToken, accessToken);
  }

  String? get accessToken => _preferences.getString(AppKeys.accessToken);

  Future<void> setFirstName(String firstName) async {
    await _box.put(AppKeys.firstname, firstName);
  }

  String getFirstName() => _box.get(AppKeys.firstname, defaultValue: '');

  Future<void> setLastName(String lastName) async {
    await _box.put(AppKeys.lastname, lastName);
  }

  String getLastName() => _box.get(AppKeys.lastname, defaultValue: '');

  Future<void> setEmail(String email) async {
    await _box.put(AppKeys.email, email);
  }

  String get email => _box.get(AppKeys.email, defaultValue: '');

  Future<void> setPassword(String password) async {
    await _box.put(AppKeys.password, password);
  }

  String? get password => _box.get(AppKeys.password);

  Future<void> clear() async {
    await Future.wait([
      _preferences.remove(AppKeys.hasProfile),
      _preferences.remove(AppKeys.accessToken),
      _box.clear(),
      _cacheBox.clear(),
    ]);
  }
}
