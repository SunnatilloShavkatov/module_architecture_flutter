import 'package:core/core.dart';
import 'package:more/src/data/datasource/more_local_data_source_impl.dart';
import 'package:more/src/data/datasource/more_remote_data_source.dart';
import 'package:more/src/data/repository/more_repository_impl.dart';
import 'package:more/src/domain/repository/more_repository.dart';
import 'package:more/src/domain/usecases/get_more_data.dart';
import 'package:more/src/more_page_factory.dart';
import 'package:more/src/presentation/more/bloc/more_bloc.dart';

final class MoreInjection implements Injection {
  const MoreInjection();

  @override
  void registerDependencies({required Injector di}) {
    di
      /// page factories
      ..registerLazySingleton<PageFactory>(() => const MorePageFactory(), instanceName: InstanceNameKeys.moreFactory)
      /// data sources
      ..registerLazySingleton<MoreLocalDataSource>(() => MoreLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<MoreRemoteDataSource>(() => MoreRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<MoreRepository>(() => MoreRepositoryImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton(() => GetMoreData(di.get()))
      /// bloc
      ..registerFactory(() => MoreBloc(di.get()));
  }
}
