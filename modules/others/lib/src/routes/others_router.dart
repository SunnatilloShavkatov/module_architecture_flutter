import "package:flutter/material.dart";
import "package:navigation/navigation.dart";
import "package:others/src/presentation/splash_page.dart";

class OthersRouter extends AppRouter {
  const OthersRouter();

  @override
  Map<String, PageRoute> getRoutes(RouteSettings settings) => {
        Routes.splash: MaterialPageRoute(settings: settings, builder: (_) => const SplashPage()),
      };
}
