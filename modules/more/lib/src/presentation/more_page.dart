// ignore_for_file: discarded_futures

import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    logMessage('MorePage');
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                context.pushNamed(Routes.settings);
              },
              child: Text(context.localizations.settings),
            ),
            CustomLoadingButton(
              child: const Text('Settings'),
              onPressed: () async {
                await context.pushNamed(Routes.settings);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: Dimensions.kPaddingAll16,
        child: Text('${packageInfo.version} (${packageInfo.buildNumber})', textAlign: TextAlign.center),
      ),
    );
  }
}
