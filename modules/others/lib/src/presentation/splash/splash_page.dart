// ignore_for_file: discarded_futures

import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

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
        AppInjector.instance.isReadySync<PackageInfo>();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(Routes.main);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.primary,
        body: Center(
          child: Text(
            'Logo',
            style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.onPrimary),
          ),
        ),
      );
}
