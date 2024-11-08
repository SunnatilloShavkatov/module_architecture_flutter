// ignore_for_file: discarded_futures

import "package:flutter/material.dart";
import "package:navigation/navigation.dart";

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(Routes.main);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text("Logo")),
      );
}
