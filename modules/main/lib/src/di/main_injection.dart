import "dart:async";

import "package:core/core.dart";
import "package:main/src/data/datasource/local/main_local_data_source_impl.dart";
import "package:main/src/data/datasource/remote/main_remote_data_source.dart";
import "package:main/src/domain/repository/main_repository.dart";

final class MainInjection implements Injection {
  const MainInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di

      /// data sources
      ..registerLazySingleton<MainRemoteDataSource>(() => MainRemoteDataSourceImpl(di.get()))
      ..registerLazySingleton<MainLocalDataSource>(() => MainLocalDataSourceImpl(di.get()))

      /// repositories
      ..registerLazySingleton<MainRepository>(() => MainRepositoryImpl(di.get(), di.get()));

    /// bloc
    // ..registerFactory(() => MainBloc(di.get(), di.get(), di.get()));
  }
}
