import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(toolbarHeight: 0),
    body: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingHor24Ver40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                Text(
                  'Handbook',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: context.color.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Dimensions.kGap8,
                Text(
                  'tizimiga hush kelibsiz',
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: context.color.textPrimary,
                  ),
                ),
                Dimensions.kGap12,
                Text(
                  'Sizni premium dastyoringiz',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(fontSize: 16, color: context.color.textSecondary),
                ),
              ],
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: CustomLoadingButton(
              onPressed: () => context.pushNamed(Routes.login),
              child: const Text('Electron pochta orqali kirish'),
            ),
          ),
          Dimensions.kGap3,
          FractionallySizedBox(
            widthFactor: 1,
            child: CustomLoadingButton(
              onPressed: () => context.pushNamed(Routes.otpLogin),
              child: const Text('Telegram orqali kirish'),
            ),
          ),
          Dimensions.kGap24,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Yordam olish',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.color.primary,
                ),
              ),
              Dimensions.kGap8,
              Icon(Icons.headset_mic_outlined, size: 20, color: context.color.primary),
            ],
          ),
          Dimensions.kGap20,
          const Spacer(),
        ],
      ),
    ),
  );
}
