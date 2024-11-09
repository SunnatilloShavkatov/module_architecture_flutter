import "package:flutter/material.dart";
import "package:main/main.dart";
import "package:more/more.dart";
import "package:navigation/navigation.dart";
import "package:others/others.dart";

sealed class AppRoutes {
  const AppRoutes._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const List<AppRouter> _routes = [
    OthersRouter(),
    MainRouter(),
    MoreRouter(),
  ];

  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    final Map<String, PageRoute> routes = {};
    for (int i = 0; i < _routes.length; i++) {
      routes.addAll(_routes[i].getRoutes(settings));
    }
    return routes[settings.name];
  }

  static Route<dynamic>? unknownRoute(RouteSettings settings) => MaterialPageRoute<void>(
        builder: (_) => NotFoundPage(settings: settings),
      );
}
