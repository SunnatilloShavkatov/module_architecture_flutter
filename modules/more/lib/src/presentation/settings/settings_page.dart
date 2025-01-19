import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.localizations.settings)),
        body: Center(
          child: GestureDetector(
            onTap: () async {
              await showModalBottomSheet<void>(
                context: context,
                builder: (_) => SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          localSource.setLocale('en');
                          context.setLocale(const Locale('en'));
                          Navigator.of(context).pop();
                        },
                        title: const Text('English'),
                      ),
                      ListTile(
                        onTap: () {
                          localSource.setLocale('uz');
                          context.setLocale(const Locale('uz'));
                          Navigator.of(context).pop();
                        },
                        title: const Text("O'zbekcha"),
                      ),
                      ListTile(
                        onTap: () {
                          localSource.setLocale('ru');
                          context.setLocale(const Locale('ru'));
                          Navigator.of(context).pop();
                        },
                        title: const Text('Russian'),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Text('Locale ${navigatorObserver.currentRoutes}'),
          ),
        ),
      );
}
