// ignore_for_file: unawaited_futures
import "dart:async";
import "dart:io";

import "package:base_dependencies/base_dependencies.dart";
import "package:core/core.dart";
import "package:core/src/connectivity/network_info.dart";

late Box<dynamic> _box;

/// internet connection
NetworkInfo get networkInfo => AppInjector.instance.get<NetworkInfo>();

Connectivity get connectivity => AppInjector.instance.get<Connectivity>();

PackageInfo get packageInfo => AppInjector.instance.get<PackageInfo>();

LocalSource get localSource => AppInjector.instance.get<LocalSource>();

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
  }
}

Future<void> _initHive() async {
  const String boxName = "flutter_module_architecture_box";
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  _box = await Hive.openBox<dynamic>(boxName);
}
