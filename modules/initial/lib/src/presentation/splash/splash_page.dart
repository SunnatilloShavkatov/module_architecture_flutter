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
  LocalSource get _localSource => AppInjector.instance.get<LocalSource>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().ignore();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await _localSource.hasProfile;
    if (!mounted) {
      return;
    }
    if (isLoggedIn) {
      context.pushReplacementNamed(Routes.mainHome);
    } else {
      context.pushReplacementNamed(Routes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Logo', style: context.textTheme.labelLarge)),
  );
}
