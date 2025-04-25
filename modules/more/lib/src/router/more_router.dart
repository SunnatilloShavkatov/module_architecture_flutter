import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:more/src/presentation/settings/settings_page.dart';
import 'package:more/src/presentation/settings/sheet/choose_theme_mode_sheet.dart';
import 'package:navigation/navigation.dart';

final class MoreRouter extends AppRouter {
  const MoreRouter();

  @override
  Map<String, PageRoute<dynamic>> getRoutes(RouteSettings settings, Injector di) => {
        Routes.settings: MaterialPageRoute(settings: settings, builder: (_) => const SettingsPage()),
        Routes.chooseThemeModeSheet: MaterialSheetRoute(
          settings: settings,
          builder: (_) => const ChooseThemeModeSheet(),
        ),
      };
}
