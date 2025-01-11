// ignore_for_file: unawaited_futures
import "dart:async";
import "dart:io";

import "package:base_dependencies/base_dependencies.dart";
import "package:core/src/connectivity/network_info.dart";
import "package:core/src/core_abstractions/injection.dart";
import "package:core/src/core_abstractions/injector.dart";
import "package:core/src/di/app_injector.dart";
import "package:core/src/local_source/local_source.dart";

class CoreInjection implements Injection {
  const CoreInjection();

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

late Box<dynamic> _box;

/// internet connection
NetworkInfo get networkInfo => AppInjector.instance.get<NetworkInfo>();

Connectivity get connectivity => AppInjector.instance.get<Connectivity>();

PackageInfo get packageInfo => AppInjector.instance.get<PackageInfo>();

LocalSource get localSource => AppInjector.instance.get<LocalSource>();

Future<void> _initHive() async {
  const String boxName = "flutter_module_architecture_box";
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  _box = await Hive.openBox<dynamic>(boxName);
}
