import 'dart:async';

import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.localizations.settings)),
    body: Center(
      child: Column(
        children: [
          Text('Locale ${AppInjector.instance.get<RouteNavigationObserver>().currentRoutes}'),
          ListTile(
            title: const Text('Choose theme mode'),
            onTap: () async {
              final themeMode = await context.pushNamed(Routes.chooseThemeModeSheet);
              if (themeMode != null && themeMode is ThemeMode && context.mounted) {
                context.setThemeMode(themeMode);
                unawaited(AppInjector.instance.get<LocalSource>().setThemeMode(themeMode));
              }
            },
          ),
        ],
      ),
    ),
  );
}
