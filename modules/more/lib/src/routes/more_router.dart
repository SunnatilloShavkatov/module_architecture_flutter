import "package:flutter/material.dart";
import "package:more/src/presentation/settings/settings_page.dart";
import "package:navigation/navigation.dart";

class MoreRouter extends AppRouter {
  const MoreRouter();

  @override
  Map<String, PageRoute> getRoutes(RouteSettings settings) => {
        Routes.settings: MaterialPageRoute(settings: settings, builder: (_) => const SettingsPage()),
      };
}
