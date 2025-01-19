import 'package:core/core.dart';
import 'package:more/src/data/datasource/local/more_local_data_source_impl.dart';
import 'package:more/src/data/datasource/remote/more_remote_data_source.dart';
import 'package:more/src/domain/repository/more_repository.dart';
import 'package:more/src/domain/usecases/get_more_data.dart';

final class MoreInjection implements Injection {
  const MoreInjection();

  @override
  void registerDependencies({required Injector di}) {
    di

      /// data sources
      ..registerLazySingleton<MoreLocalDataSource>(() => MoreLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<MoreRemoteDataSource>(() => MoreRemoteDataSourceImpl(di.get()))

      /// repositories
      ..registerLazySingleton<MoreRepository>(() => MoreRepositoryImpl(di.get(), di.get()))

      /// usecases
      ..registerFactory(() => GetMoreData(di.get()));

    /// bloc
    // ..registerFactory(() => MainBloc(di.get(), di.get(), di.get()));
  }
}
