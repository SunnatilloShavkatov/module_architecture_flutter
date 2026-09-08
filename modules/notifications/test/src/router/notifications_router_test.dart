import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/router/notifications_router.dart';

class _MockInjector extends Mock implements Injector;

void main() {
  test('NotificationsRouter returns configured routes', () {
    final di = _MockInjector();
    const router = NotificationsRouter();

    final routes = router.getRouters(di);

    expect(routes.length, 3);
    expect(routes.any((r) => r is GoRoute && r.path == Routes.notifications), isTrue);
    expect(routes.any((r) => r is MaterialSheetRoute && r.path == Routes.notificationsFilterSheet), isTrue);
    expect(routes.any((r) => r is MaterialDialogRoute && r.path == Routes.clearNotificationsDialog), isTrue);
  });
}
