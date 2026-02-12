import 'package:components/src/extension/app_options_extension.dart';
import 'package:components/src/theme/themes.dart';
import 'package:flutter/material.dart';

/// Read-only theme accessors.
///
/// Use [ThemeContextExt] for reading theme data (colors, text styles).
/// Use [AppOptionsContextExt] from `app_options_extension.dart` for
/// mutating app-level state (theme mode, locale).
///
/// Prefer [color] / [textStyle] (custom extensions) for app-specific tokens.
/// Use [colorScheme] / [textTheme] only for Material component overrides.
extension ThemeContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  ThemeColors get color => theme.extension<ThemeColors>()!;

  ThemeTextStyles get textStyle => theme.extension<ThemeTextStyles>()!;
}
