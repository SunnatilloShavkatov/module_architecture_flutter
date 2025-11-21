import 'package:base_dependencies/base_dependencies.dart';
import 'package:components/components.dart';
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
    Future.delayed(const Duration(seconds: 1), () async {
      AppInjector.instance.isReadySync<PackageInfo>();
      if (mounted) {
        await Navigator.pushReplacementNamed(context, Routes.main);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Logo', style: context.textTheme.labelLarge)),
  );
}
