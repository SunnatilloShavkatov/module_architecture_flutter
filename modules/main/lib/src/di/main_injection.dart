import 'dart:async';

import 'package:core/core.dart';
import 'package:main/src/data/datasource/main_local_data_source.dart';
import 'package:main/src/data/datasource/main_remote_data_source.dart';
import 'package:main/src/data/repository/main_repository_impl.dart';
import 'package:main/src/domain/repository/main_repo.dart';

final class MainInjection implements Injection {
  const MainInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<MainLocalDataSource>(() => MainLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<MainRemoteDataSource>(() => MainRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<MainRepo>(() => MainRepoImpl(di.get(), di.get()));

    /// bloc
    // ..registerFactory(() => MainBloc(di.get(), di.get(), di.get()));
  }
}
