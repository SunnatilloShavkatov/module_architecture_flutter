import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:more/src/presentation/settings/settings_page.dart';
import 'package:more/src/presentation/settings/sheet/choose_theme_mode_sheet.dart';
import 'package:navigation/navigation.dart';

final class MoreRouter implements AppRouter {
  const MoreRouter();

  @override
  Map<String, ModalRoute<dynamic>> getRoutes(RouteSettings settings, Injector di) => {
    Routes.settings: MaterialPageRoute(settings: settings, builder: (_) => const SettingsPage()),
    Routes.chooseThemeModeSheet: MaterialSheetRoute(settings: settings, builder: (_) => const ChooseThemeModeSheet()),
  };
}
