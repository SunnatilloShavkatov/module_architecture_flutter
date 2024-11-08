import "package:flutter/material.dart";
import "package:main/src/presentation/main_page.dart";
import "package:navigation/navigation.dart";

class MainRouter extends AppRouter {
  const MainRouter();

  @override
  Map<String, PageRoute> getRoutes(RouteSettings settings) => {
        Routes.main: MaterialPageRoute(settings: settings, builder: (_) => const MainPage()),
      };
}