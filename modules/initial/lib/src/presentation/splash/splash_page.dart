import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:platform_methods/platform_methods.dart';

part 'mixin/splash_mixin.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SplashMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Logo', style: context.textTheme.labelLarge)),
  );
}
