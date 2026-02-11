import 'package:components/src/options/app_options.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension AppOptionsContextExt on BuildContext {
  AppOptions get options => AppOptions.of(this);

  void setLocale(Locale locale) {
    Intl.defaultLocale = locale.toString();
    AppOptions.update(this, AppOptions.of(this, listen: false).copyWith(locale: locale));
  }

  void setThemeMode(ThemeMode themeMode) {
    AppOptions.update(this, AppOptions.of(this, listen: false).copyWith(themeMode: themeMode));
  }
}
