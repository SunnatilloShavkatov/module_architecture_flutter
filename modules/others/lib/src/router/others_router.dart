import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:others/src/presentation/internet_connection/internet_connection_page.dart';
import 'package:others/src/presentation/splash/splash_page.dart';

final class OthersRouter extends AppRouter {
  const OthersRouter();

  @override
  Map<String, PageRoute> getRoutes(RouteSettings settings, Injector di) => {
        Routes.splash: MaterialPageRoute(settings: settings, builder: (_) => const SplashPage()),
        Routes.noInternet: MaterialPageRoute(settings: settings, builder: (_) => const InternetConnectionPage()),
      };
}
