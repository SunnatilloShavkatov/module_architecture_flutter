import 'dart:async';

import 'package:core/core.dart';
import 'package:home/src/data/datasource/home_local_data_source.dart';
import 'package:home/src/data/datasource/home_remote_data_source.dart';
import 'package:home/src/data/repository/home_repository_impl.dart';
import 'package:home/src/domain/repository/home_repo.dart';
import 'package:home/src/domain/usecases/get_home_appointments.dart';
import 'package:home/src/domain/usecases/get_home_businesses.dart';
import 'package:home/src/domain/usecases/get_home_categories.dart';
import 'package:home/src/home_page_factory.dart';
import 'package:home/src/presentation/main/bloc/home_bloc.dart';

final class HomeInjection implements Injection {
  const HomeInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// factories
      ..registerLazySingleton<PageFactory>(() => const HomePageFactory(), instanceName: InstanceNameKeys.homeFactory)
      /// data sources
      ..registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<HomeRepo>(() => HomeRepoImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton(() => GetHomeCategories(di.get()))
      ..registerLazySingleton(() => GetHomeBusinesses(di.get()))
      ..registerLazySingleton(() => GetHomeAppointments(di.get()))
      /// bloc
      ..registerFactory(() => HomeBloc(di.get(), di.get(), di.get(), di.get()));
  }
}
