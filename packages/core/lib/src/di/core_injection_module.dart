// ignore_for_file: unawaited_futures
import "dart:async";
import "dart:io";

import "package:base_dependencies/base_dependencies.dart";
import "package:core/src/connectivity/network_info.dart";
import "package:core/src/core_abstractions/injection.dart";
import "package:core/src/di/injector.dart";
import "package:core/src/local_source/local_source.dart";

late Box<dynamic> _box;

class CoreInjectionModule implements Injection {
  const CoreInjectionModule();

  @override
  FutureOr<void> registerDependencies({required Injector di}) async {
    /// External
    await _initHive();
    di
      ..registerSingleton<LocalSource>(LocalSource(_box))
      ..registerLazySingleton<Connectivity>(Connectivity.new)
      ..registerLazySingleton(InternetConnectionChecker.createInstance)
      ..registerSingletonAsync<PackageInfo>(PackageInfo.fromPlatform)
      ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di.get()));
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

Future<void> _initHive() async {
  const String boxName = "flutter_module_architecture_box";
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  _box = await Hive.openBox<dynamic>(boxName);
}
