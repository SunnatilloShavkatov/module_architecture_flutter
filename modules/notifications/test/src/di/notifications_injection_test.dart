import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/src/data/datasource/notifications_local_data_source.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/di/notifications_injection.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';
import 'package:notifications/src/domain/usecases/clear_all_notifications.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/domain/usecases/get_unread_notifications_count.dart';
import 'package:notifications/src/domain/usecases/mark_notification_as_read.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';

final class _TestInjector implements Injector {
  final List<Type> singletons = [];
  final List<Type> factories = [];
  final Map<String, Type> named = {};

  @override
  void registerLazySingleton<T extends Object>(T Function() factory, {String? instanceName}) {
    singletons.add(T);
    if (instanceName != null) {
      named[instanceName] = T;
    }
  }

  @override
  void registerFactory<T extends Object>(T Function() factoryFunc) {
    factories.add(T);
  }

  @override
  T get<T extends Object>({String? instanceName}) => throw UnimplementedError();

  @override
  Future<T> getAsync<T extends Object>({String? instanceName}) => throw UnimplementedError();

  @override
  void registerSingleton<T extends Object>(T instance) {}

  @override
  void registerSingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposableFunc<T>? dispose,
  }) {}

  @override
  void registerLazySingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    DisposableFunc<T>? dispose,
  }) {}

  @override
  void unregister<T extends Object>() {}

  @override
  bool isReadySync<T extends Object>({Object? instance, String? instanceName}) => true;

  @override
  Future<void> isReady<T extends Object>({
    Object? instance,
    String? instanceName,
    Duration? timeout,
    Object? callee,
  }) async {}

  @override
  Future<void> allReady({Duration? timeout, bool ignorePendingAsyncCreation = false}) async {}
}

void main() {
  test('NotificationsInjection registers all dependencies', () async {
    final di = _TestInjector();
    const injection = NotificationsInjection();

    await injection.registerDependencies(di: di);

    expect(di.singletons, contains(NotificationsLocalDataSource));
    expect(di.singletons, contains(NotificationsRemoteDataSource));
    expect(di.singletons, contains(NotificationsRepository));
    expect(di.singletons, contains(GetNotifications));
    expect(di.singletons, contains(MarkNotificationAsRead));
    expect(di.singletons, contains(ClearAllNotifications));
    expect(di.singletons, contains(GetUnreadNotificationsCount));
    expect(di.named, contains(InstanceNameKeys.getUnreadNotificationsCountInteractor));
    expect(di.named, contains(InstanceNameKeys.notificationItemFactory));
    expect(di.factories, contains(NotificationsBloc));
  });
}
