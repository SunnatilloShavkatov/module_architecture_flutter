import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

final class LocalSource {
  const LocalSource(this._box, this._cacheBox);

  final Box<dynamic> _box;
  final Box<dynamic> _cacheBox;

  bool get hasProfile => _box.get(AppKeys.hasProfile, defaultValue: false);

  Future<void> setHasProfile({required bool value}) async {
    await _box.put(AppKeys.hasProfile, value);
  }

  Future<void> setLocale(String locale) async {
    await _box.put(AppKeys.locale, locale);
  }

  String get locale => _box.get(AppKeys.locale, defaultValue: defaultLocale);

  ThemeMode get themeMode => switch (_box.get(AppKeys.themeMode)) {
        'system' => ThemeMode.system,
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> setThemeMode(ThemeMode mode) async {
    await _box.put(AppKeys.themeMode, mode.name);
  }

  Future<void> setAccessToken(String accessToken) async {
    await _box.put(AppKeys.accessToken, accessToken);
  }

  String get accessToken => _box.get(AppKeys.accessToken, defaultValue: '');

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
    await _box.clear();
    await _cacheBox.clear();
  }
}
