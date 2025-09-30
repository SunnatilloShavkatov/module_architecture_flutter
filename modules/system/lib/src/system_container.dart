import 'package:core/core.dart';
import 'package:system/src/router/system_router.dart';

final class SystemContainer implements ModuleContainer {
  const SystemContainer();

  @override
  AppRouter get router => const SystemRouter();

  @override
  Injection? get injection => null;
}
