import 'package:core/core.dart';
import 'package:home/src/di/home_injection.dart';
import 'package:home/src/router/home_router.dart';
import 'package:navigation/navigation.dart';

final class HomeContainer implements ModuleContainer {
  const HomeContainer();

  @override
  AppRouter<RouteBase> get router => const HomeRouter();

  @override
  Injection get injection => const HomeInjection();
}
