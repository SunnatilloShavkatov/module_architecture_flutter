import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class AppNavigationServiceImpl implements AppNavigationService {
  const AppNavigationServiceImpl(this._rootNavigatorKey, this._navigatorObserver);

  final RouteNavigationObserver _navigatorObserver;
  final GlobalKey<NavigatorState> _rootNavigatorKey;

  @override
  Future<void> navigateToNoInternet() async {
    if (isCurrentPath(Routes.noInternet)) {
      return;
    }
    final context = _rootNavigatorKey.currentContext;
    if (context != null) {
      await context.pushNamed(Routes.noInternet);
    }
  }

  @override
  void navigateToInitial() {
    final context = _rootNavigatorKey.currentContext;
    if (context != null) {
      context.goNamed(Routes.initial);
    }
  }

  @override
  bool isCurrentPath(String path) => _navigatorObserver.currentRoutes.contains(path);
}
