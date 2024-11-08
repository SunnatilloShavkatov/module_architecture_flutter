import "package:base_dependencies/base_dependencies.dart";
import "package:core/core.dart";
import "package:flutter/material.dart";

final class LocalSource {
  LocalSource(this.box);

  final Box<dynamic> box;

  bool get hasProfile => box.get(AppKeys.hasProfile, defaultValue: false);

  Future<void> setHasProfile({required bool value}) async {
    await box.put(AppKeys.hasProfile, value);
  }

  Future<void> setLocale(String locale) async {
    await box.put(AppKeys.locale, locale);
  }

  String get locale => box.get(AppKeys.locale, defaultValue: defaultLocale);

  ThemeMode get themeMode => switch (box.get(AppKeys.themeMode)) {
        "system" => ThemeMode.system,
        "light" => ThemeMode.light,
        "dark" => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> setThemeMode(ThemeMode mode) async {
    await box.put(AppKeys.themeMode, mode.name);
  }

  Future<void> setAccessToken(String accessToken) async {
    await box.put(AppKeys.accessToken, accessToken);
  }

  String get accessToken => box.get(AppKeys.accessToken, defaultValue: "");

  Future<void> setFirstName(String firstName) async {
    await box.put(AppKeys.firstname, firstName);
  }

  String getFirstName() => box.get(AppKeys.firstname, defaultValue: "");

  Future<void> setLastName(String lastName) async {
    await box.put(AppKeys.lastname, lastName);
  }

  String getLastName() => box.get(AppKeys.lastname, defaultValue: "");

  Future<void> setEmail(String email) async {
    await box.put(AppKeys.email, email);
  }

  String get email => box.get(AppKeys.email, defaultValue: "");

  Future<void> setPassword(String password) async {
    await box.put(AppKeys.password, password);
  }

  String? get password => box.get(AppKeys.password);

  Future<void> clear() async {
    await box.clear();
  }
}
