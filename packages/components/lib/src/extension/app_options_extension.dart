import 'package:components/src/options/app_options.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

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
