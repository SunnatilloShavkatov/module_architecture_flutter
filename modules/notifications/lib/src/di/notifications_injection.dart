import 'dart:async' show FutureOr;

import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_local_data_source.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/data/repository/notifications_repository_impl.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';

final class NotificationsInjection implements Injection {
  const NotificationsInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      ..registerLazySingleton<NotificationsLocalDataSource>(NotificationsLocalDataSourceImpl.new)
      ..registerLazySingleton<NotificationsRemoteDataSource>(() => NotificationsRemoteDataSourceImpl(di.get()))
      ..registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(di.get(), di.get()))
      ..registerLazySingleton(() => GetNotifications(di.get()))
      ..registerFactory(() => NotificationsBloc(di.get()));
  }
}
