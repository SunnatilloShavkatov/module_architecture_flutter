import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/di/notifications_injection.dart';
import 'package:notifications/src/router/notifications_router.dart';

final class NotificationsContainer implements ModuleContainer {
  const NotificationsContainer();

  @override
  AppRouter<RouteBase> get router => const NotificationsRouter();

  @override
  Injection get injection => const NotificationsInjection();
}
