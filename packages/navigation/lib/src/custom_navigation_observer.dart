import "package:flutter/material.dart";

@immutable
class CustomNavigatorObserver extends NavigatorObserver {
  final List<String> routes = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      routes.add(route.settings.name!);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      routes.remove(route.settings.name);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route.settings.name != null) {
      routes.remove(route.settings.name);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute?.settings.name != null) {
      routes.remove(oldRoute!.settings.name);
    }
    if (newRoute?.settings.name != null) {
      routes.add(newRoute!.settings.name!);
    }
  }
}
