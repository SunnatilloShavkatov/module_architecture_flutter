import 'dart:async';

import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/data/repo/auth_repo_impl.dart';
import 'package:auth/src/domain/repo/auth_repo.dart';
import 'package:core/core.dart';

final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      ..registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di.get()))
      ..registerLazySingleton<AuthRepo>(
        () => AuthRepoImpl(di.get<AuthRemoteDataSource>(), di.get<AuthLocalDataSource>()),
      );
  }
}
