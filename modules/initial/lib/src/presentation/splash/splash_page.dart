import 'package:components/components.dart';
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
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.pushReplacementNamed(Routes.welcome);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Logo', style: context.textTheme.labelLarge)),
  );
}
