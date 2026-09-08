import 'dart:async' show FutureOr;

import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_local_data_source.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/data/repository/notifications_repository_impl.dart';
import 'package:notifications/src/domain/interactor/get_unread_notifications_count_interactor.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';
import 'package:notifications/src/domain/usecases/clear_all_notifications.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/domain/usecases/get_unread_notifications_count.dart';
import 'package:notifications/src/domain/usecases/mark_notification_as_read.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';
import 'package:notifications/src/presentation/notifications/factory/notification_item_factory.dart';

final class NotificationsInjection implements Injection {
  const new();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<NotificationsLocalDataSource>(NotificationsLocalDataSourceImpl.new)
      ..registerLazySingleton<NotificationsRemoteDataSource>(() => NotificationsRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton(() => GetNotifications(di.get()))
      ..registerLazySingleton(() => MarkNotificationAsRead(di.get()))
      ..registerLazySingleton(() => ClearAllNotifications(di.get()))
      ..registerLazySingleton(() => GetUnreadNotificationsCount(di.get()))
      /// interactors
      ..registerLazySingleton<ModuleInteractor<int, NoParams>>(
        () => GetUnreadNotificationsCountInteractor(di.get()),
        instanceName: InstanceNameKeys.getUnreadNotificationsCountInteractor,
      )
      /// widget factories
      ..registerLazySingleton<WidgetFactory<NotificationItemArgs>>(
        NotificationItemFactory.new,
        instanceName: InstanceNameKeys.notificationItemFactory,
      )
      /// blocs
      ..registerFactory(() => NotificationsBloc(di.get(), di.get(), di.get()));
  }
}
