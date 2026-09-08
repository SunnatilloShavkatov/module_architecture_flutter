import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:platform_methods/platform_methods.dart';

part 'mixin/splash_mixin.dart';

class SplashPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SplashMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text(context.l10n.appName, style: context.textStyle.defaultW600x20)),
  );
}
