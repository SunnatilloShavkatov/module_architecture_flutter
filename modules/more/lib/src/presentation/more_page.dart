// ignore_for_file: discarded_futures

import 'package:base_dependencies/base_dependencies.dart';
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
        child: FutureBuilder<PackageInfo>(
          future: AppInjector.instance.getAsync<PackageInfo>(),
          builder: (_, snapshot) {
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }
            return Text('${snapshot.data!.version} (${snapshot.data!.buildNumber})', textAlign: TextAlign.center);
          },
        ),
      ),
    );
  }
}
