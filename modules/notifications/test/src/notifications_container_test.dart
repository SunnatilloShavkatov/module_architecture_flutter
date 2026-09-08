import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/notifications.dart';
import 'package:notifications/src/di/notifications_injection.dart';
import 'package:notifications/src/router/notifications_router.dart';

void main() {
  test('NotificationsContainer exposes router and injection', () {
    const container = NotificationsContainer();
    expect(container.router, isA<NotificationsRouter>());
    expect(container.injection, isA<NotificationsInjection>());
    expect(container, isA<ModuleContainer>());
  });
}
