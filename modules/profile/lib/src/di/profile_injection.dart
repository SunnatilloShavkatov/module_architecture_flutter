import 'package:core/core.dart';
import 'package:profile/src/data/datasource/profile_local_data_source_impl.dart';
import 'package:profile/src/data/datasource/profile_remote_data_source.dart';
import 'package:profile/src/data/repository/profile_repository_impl.dart';
import 'package:profile/src/domain/repository/profile_repository.dart';
import 'package:profile/src/domain/usecases/get_profile_user.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:profile/src/profile_page_factory.dart';

final class ProfileInjection implements Injection {
  const ProfileInjection();

  @override
  void registerDependencies({required Injector di}) {
    di
      /// page factories
      ..registerLazySingleton<PageFactory>(
        () => const ProfilePageFactory(),
        instanceName: InstanceNameKeys.profileFactory,
      )
      /// data sources
      ..registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton(() => GetProfileUser(di.get()))
      /// bloc
      ..registerFactory(() => ProfileBloc(di.get(), di.get()));
  }
}
