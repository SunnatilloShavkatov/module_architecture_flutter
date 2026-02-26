import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeAreaWithMinimum(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Column(
              children: [
                Text(
                  'Handbook',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: context.color.primary, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                Dimensions.kGap8,
                Text(
                  'tizimiga hush kelibsiz',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: context.color.textPrimary, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                Dimensions.kGap12,
                Text(
                  'Sizni premium dastyoringiz',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.color.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomLoadingButton(
                onPressed: () => context.pushNamed(Routes.login),
                child: const Text('Electron pochta orqali kirish'),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: CustomLoadingButton(
                onPressed: () => context.pushNamed(Routes.otpLogin),
                child: const Text('Telegram orqali kirish'),
              ),
            ),
            Dimensions.kGap24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Yordam olish', style: TextStyle(color: context.color.primary)),
                const SizedBox(width: 8),
                Icon(Icons.headset_mic_outlined, size: 20, color: context.color.primary),
              ],
            ),
            const SizedBox(height: 20),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}
