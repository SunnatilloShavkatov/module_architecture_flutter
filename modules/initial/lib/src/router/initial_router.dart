import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:initial/src/presentation/splash/splash_page.dart';
import 'package:navigation/navigation.dart';

final class InitialRouter implements AppRouter {
  const InitialRouter();

  @override
  Map<String, ModalRoute<dynamic>> getRoutes(RouteSettings settings, Injector di) => {
    Routes.initial: MaterialPageRoute(settings: settings, builder: (_) => const SplashPage()),
  };
}
