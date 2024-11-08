import "package:flutter/material.dart";
import "package:main/main.dart";
import "package:more/more.dart";
import "package:others/others.dart";

sealed class AppRoutes {
  const AppRoutes._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const _routes = [
    OthersRouter(),
    MainRouter(),
    MoreRouter(),
  ];

  static Route<dynamic>? getRoutes(RouteSettings settings) {
    final Map<String, PageRoute> routes = {};
    for (final e in _routes) {
      routes.addAll(e.getRoutes(settings));
    }
    return routes[settings.name];
  }
}
