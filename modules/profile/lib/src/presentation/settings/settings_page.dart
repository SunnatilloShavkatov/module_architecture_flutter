import 'dart:async';

import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.settings)),
    body: Center(
      child: Column(
        children: [
          ListTile(
            title: Text(context.l10n.chooseThemeMode),
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
