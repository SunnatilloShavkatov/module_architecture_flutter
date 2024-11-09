import "package:core/core.dart";
import "package:module_architecture_flutter/router/app_routes.dart";
import "package:navigation/navigation.dart";

const _injections = [CoreInjectionModule()];

Future<void> initDI() async {
  final Injector injector = AppInjector.instance
    ..registerLazySingleton(() => AppRoutes.navigatorKey, instanceName: RouteKeys.navigatorKey)
    ..registerLazySingleton(CustomNavigatorObserver.new, instanceName: RouteKeys.navigatorObserver);

  /// register injections
  await Future.forEach(
    _injections,
    (Injection injection) async {
      await injection.registerDependencies(di: injector);
    },
  );
}
