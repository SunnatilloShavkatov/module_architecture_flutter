import 'dart:async';
import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/data/repo/auth_repo_impl.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:core/core.dart';

final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// data
      ..registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di.get()))
      /// domain
      ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton<Login>(() => Login(di.get()))
      /// bloc
      ..registerFactory(() => LoginBloc(di.get()));
  }
}
