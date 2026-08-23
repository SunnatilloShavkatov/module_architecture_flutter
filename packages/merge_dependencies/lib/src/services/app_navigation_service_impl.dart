import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class AppNavigationServiceImpl implements AppNavigationService {
  const new(this._rootNavigatorKey, this._navigatorObserver);

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
