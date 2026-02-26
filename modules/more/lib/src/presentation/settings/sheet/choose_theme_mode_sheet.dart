import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class ChooseThemeModeSheet extends StatelessWidget {
  const ChooseThemeModeSheet({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    minimum: Dimensions.kPaddingAll16,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Choose theme mode', style: context.textTheme.headlineLarge, textAlign: TextAlign.center),
        Dimensions.kGap32,
        CustomLoadingButton(
          onPressed: () {
            context.pop(ThemeMode.system);
          },
          child: const Text('Device mode'),
        ),
        Dimensions.kGap16,
        CustomLoadingButton(
          onPressed: () {
            context.pop(ThemeMode.dark);
          },
          child: const Text('Dark mode'),
        ),
        Dimensions.kGap16,
        CustomLoadingButton(
          onPressed: () {
            context.pop(ThemeMode.light);
          },
          child: const Text('Light mode'),
        ),
      ],
    ),
  );
}
