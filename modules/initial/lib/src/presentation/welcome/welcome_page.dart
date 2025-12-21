import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dimensions.kSpacer,
          Text(
            context.localizations.handbookTitle,
            style: context.textStyle.defaultW700x24.copyWith(color: context.color.primary),
            textAlign: TextAlign.center,
          ),
          Dimensions.kGap16,
          Text(
            context.localizations.welcomeSubtitle,
            style: context.textStyle.defaultW700x24.copyWith(color: context.color.textPrimary),
            textAlign: TextAlign.center,
          ),
          Dimensions.kGap12,
          Text(
            context.localizations.welcomeDescription,
            style: context.textStyle.defaultW400x14.copyWith(color: context.color.textSecondary),
            textAlign: TextAlign.center,
          ),
          Dimensions.kSpacer,
          CustomLoadingButton(
            onPressed: () {
              context.pushReplacementNamed(Routes.mainHome);
            },
            child: Text(context.localizations.proceedButton),
          ),
          Dimensions.kGap16,
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.headset_mic, color: context.color.primary, size: 20),
            label: Text(
              context.localizations.getHelp,
              style: context.textStyle.defaultW400x14.copyWith(color: context.color.primary),
            ),
          ),
          Dimensions.kGap32,
        ],
      ),
    ),
  );
}
