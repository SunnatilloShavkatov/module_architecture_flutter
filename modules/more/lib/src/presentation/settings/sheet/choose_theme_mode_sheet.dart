import 'package:components/components.dart';
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
              context.localizations.theme,
              style: context.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Dimensions.kGap32,
            CustomOutlinedButton(
              onPressed: () {
                Navigator.pop(context, ThemeMode.system);
              },
              child: Text(context.localizations.device_mode),
            ),
            Dimensions.kGap16,
            CustomOutlinedButton(
              onPressed: () {
                Navigator.pop(context, ThemeMode.dark);
              },
              child: Text(context.localizations.dark_mode),
            ),
            Dimensions.kGap16,
            CustomOutlinedButton(
              onPressed: () {
                Navigator.pop(context, ThemeMode.light);
              },
              child: Text(context.localizations.light_mode),
            ),
          ],
        ),
      );
}
