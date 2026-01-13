import 'package:core/core.dart';
import 'package:main/src/di/main_injection.dart';
import 'package:main/src/router/main_router.dart';
import 'package:navigation/navigation.dart';

final class MainContainer implements ModuleContainer {
  const MainContainer();

  @override
  AppRouter<RouteBase> get router => const MainRouter();

  @override
  Injection get injection => const MainInjection();
}
