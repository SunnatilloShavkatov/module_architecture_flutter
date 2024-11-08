import "package:core/core.dart";
import "package:module_architecture_flutter/router/app_routes.dart";

const _injections = [CoreInjectionModule()];

Future<void> initDI() async {
  final Injector injector = AppInjector.instance
    ..registerLazySingleton(() => AppRoutes.navigatorKey, instanceName: "navigator_key");

  /// register injections
  await Future.forEach(
    _injections,
    (Injection injection) async {
      await injection.registerDependencies(di: injector);
    },
  );
}
