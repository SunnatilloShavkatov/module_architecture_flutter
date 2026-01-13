import 'package:core/core.dart';
import 'package:more/src/di/more_injection.dart';
import 'package:more/src/router/more_router.dart';
import 'package:navigation/navigation.dart';

final class MoreContainer implements ModuleContainer {
  const MoreContainer();

  @override
  AppRouter<RouteBase> get router => const MoreRouter();

  @override
  Injection get injection => const MoreInjection();
}
