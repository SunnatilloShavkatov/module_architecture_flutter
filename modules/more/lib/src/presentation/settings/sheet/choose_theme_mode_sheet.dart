import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ChooseThemeModeSheet extends StatelessWidget {
  const ChooseThemeModeSheet({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        minimum: Dimensions.kPaddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Choose theme mode',
              style: context.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Dimensions.kGap32,
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, ThemeMode.system);
              },
              child: const Text('Device mode'),
            ),
            Dimensions.kGap16,
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, ThemeMode.dark);
              },
              child: const Text('Dark mode'),
            ),
            Dimensions.kGap16,
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, ThemeMode.light);
              },
              child: const Text('Light mode'),
            ),
          ],
        ),
      );
}
