import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:system/src/router/system_router.dart';

final class SystemContainer implements ModuleContainer {
  const SystemContainer();

  @override
  AppRouter<RouteBase> get router => const SystemRouter();

  @override
  Injection? get injection => null;
}
