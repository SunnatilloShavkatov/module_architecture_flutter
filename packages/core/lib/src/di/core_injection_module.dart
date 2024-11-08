import "dart:async";

import "package:core/src/core_abstractions/injection.dart";
import "package:core/src/di/injector.dart";

class CoreInjectionModule implements Injection {
  @override
  FutureOr<void> registerDependencies({required Injector di}) async {
    // di
    //   ..registerSingleton<NetworkProvider>(NetworkProvider())
    //
    //   // register network provider for refresh token
    //   ..registerLazySingleton<NetworkProvider>(
    //     () => NetworkProvider(withRefreshTokenInterceptor: false),
    //     instanceName: "refresh_token",
    //   )
    //   ..registerLazySingleton<CoreRefresh>(() => CoreRefresh())
    //   ..registerLazySingleton<MyIdService>(() => MyIdService())
    //   ..registerSingleton<AnalyticsService>(AnalyticsService()..init());
  }
}
