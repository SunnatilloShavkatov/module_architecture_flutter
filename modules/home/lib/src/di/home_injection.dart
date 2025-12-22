import 'dart:async';

import 'package:core/core.dart';
import 'package:home/src/data/datasource/home_local_data_source.dart';
import 'package:home/src/data/datasource/home_remote_data_source.dart';
import 'package:home/src/data/repository/home_repository_impl.dart';
import 'package:home/src/domain/repository/home_repo.dart';
import 'package:home/src/home_page_factory.dart';

final class HomeInjection implements Injection {
  const HomeInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// factories
      ..registerLazySingleton(() => const HomePageFactory(), instanceName: InstanceNameKeys.homeFactory)
      /// data sources
      ..registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<HomeRepo>(() => HomeRepoImpl(di.get(), di.get()));

    /// bloc
    // ..registerFactory(() => MainBloc(di.get(), di.get(), di.get()));
  }
}
