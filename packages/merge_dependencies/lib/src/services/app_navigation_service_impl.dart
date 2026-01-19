import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

class AppNavigationServiceImpl implements AppNavigationService {
  const AppNavigationServiceImpl();

  @override
  Future<void> navigateToNoInternet() async {
    if (isCurrentPath(Routes.noInternet)) {
      return;
    }
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      await context.pushNamed(Routes.noInternet);
    }
  }

  @override
  void navigateToInitial() {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      context.goNamed(Routes.initial);
    }
  }

  @override
  bool isCurrentPath(String path) => navigatorObserver.currentRoutes.contains(path);
}
