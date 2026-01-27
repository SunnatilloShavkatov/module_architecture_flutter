import 'dart:async';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/data/repo/auth_repo_impl.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/login_usecase.dart';
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:core/core.dart';

final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di.get()))
      ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(di.get()))
      ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(di.get()))
      ..registerFactory(() => LoginBloc(loginUseCase: di.get()));
  }
}
