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
              Text('Locale ${navigatorObserver.currentRoutes}'),
              ListTile(
                title: const Text('Choose theme mode'),
                onTap: () async {
                  final themeMode = await Navigator.pushNamed(context, Routes.chooseThemeModeSheet);
                  if (themeMode != null && themeMode is ThemeMode && context.mounted) {
                    context.setThemeMode(themeMode);
                  }
                },
              ),
            ],
          ),
        ),
      );
}
