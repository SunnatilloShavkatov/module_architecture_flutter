import 'package:auth/src/router/auth_router.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';

class _MockInjector extends Mock implements Injector {}

void main() {
  late _MockInjector mockInjector;
  const router = AuthRouter();

  setUp(() {
    mockInjector = _MockInjector();
  });

  group('AuthRouter', () {
    // getRouters() creates GoRoute objects with lazy builders — the injector
    // is only called when the page is actually navigated to, not here.
    test('returns correct number of routes with valid paths', () {
      final routes = router.getRouters(mockInjector);

      expect(routes.length, 2);
      expect(routes[0].path, Routes.login);
      expect(routes[1].path, Routes.otpLogin);
    });

    test('route names match paths', () {
      final routes = router.getRouters(mockInjector);

      expect(routes[0].name, Routes.login);
      expect(routes[1].name, Routes.otpLogin);
    });
  });
}
