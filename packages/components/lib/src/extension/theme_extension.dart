import 'package:components/src/options/app_options.dart';
import 'package:components/src/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  ThemeColors get color => theme.extension<ThemeColors>()!;

  ThemeTextStyles get textStyle => theme.extension<ThemeTextStyles>()!;

  AppOptions get options => AppOptions.of(this);

  void setLocale(Locale locale) {
    Intl.defaultLocale = locale.toString();
    AppOptions.update(this, AppOptions.of(this, listen: false).copyWith(locale: locale));
  }

  void setThemeMode(ThemeMode themeMode) {
    AppOptions.update(this, AppOptions.of(this, listen: false).copyWith(themeMode: themeMode));
  }
}
