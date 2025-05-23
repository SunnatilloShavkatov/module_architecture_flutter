import 'package:flutter/material.dart';

@immutable
final class RouteNavigationObserver extends NavigatorObserver {
  @protected
  final List<String> _routes = [];

  List<String> get currentRoutes => _routes;

  @override
  void didPush(Route<void> route, Route<void>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      _routes.add(route.settings.name!);
    }
  }

  @override
  void didPop(Route<void> route, Route<void>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      _routes.remove(route.settings.name);
    }
  }

  @override
  void didRemove(Route<void> route, Route<void>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route.settings.name != null) {
      _routes.remove(route.settings.name);
    }
  }

  @override
  void didReplace({Route<void>? newRoute, Route<void>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute?.settings.name != null) {
      _routes.remove(oldRoute!.settings.name);
    }
    if (newRoute?.settings.name != null) {
      _routes.add(newRoute!.settings.name!);
    }
  }
}
