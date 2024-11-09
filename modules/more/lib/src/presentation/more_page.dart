// ignore_for_file: discarded_futures

import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:navigation/navigation.dart";

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    logMessage("MorePage");
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.settings);
          },
          child: Text(context.localizations.settings),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: Dimensions.kPaddingAll16,
        child: Text(
          "${packageInfo.version} (${packageInfo.buildNumber})",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
