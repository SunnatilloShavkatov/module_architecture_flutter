import 'package:core/src/core_abstractions/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

@protected
final GetIt _getIt = GetIt.instance;

final class AppInjector implements Injector {
  const AppInjector._();

  static const AppInjector instance = AppInjector._();

  @override
  void registerLazySingleton<T extends Object>(T Function() function, {String? instanceName}) {
    assert(
      !_getIt.isRegistered<T>(instanceName: instanceName),
      'Type $T with instance name $instanceName is already registered',
    );
    _getIt.registerLazySingleton<T>(function, instanceName: instanceName);
  }

  @override
  void registerSingleton<T extends Object>(T instance, {String? instanceName}) {
    assert(
      !_getIt.isRegistered<T>(instanceName: instanceName),
      'Type $T with instance name $instanceName is already registered',
    );
    _getIt.registerSingleton<T>(instance, instanceName: instanceName);
  }

  @override
  T get<T extends Object>({String? instanceName}) => _getIt.get<T>(instanceName: instanceName);

  @override
  Future<T> getAsync<T extends Object>({String? instanceName}) => _getIt.getAsync<T>(instanceName: instanceName);

  @override
  Future<void> unregister<T extends Object>() async => _getIt.unregister<T>();

  @override
  void registerFactory<T extends Object>(T Function() function) {
    assert(!_getIt.isRegistered<T>(), 'Type $T is already registered');
    _getIt.registerFactory<T>(function);
  }

  @override
  void registerSingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposableFunc<T>? dispose,
  }) {
    assert(
      !_getIt.isRegistered<T>(instanceName: instanceName),
      'Type $T with instance name $instanceName is already registered',
    );
    _getIt.registerSingletonAsync<T>(
      factoryFunc,
      dispose: dispose,
      dependsOn: dependsOn,
      signalsReady: signalsReady,
      instanceName: instanceName,
    );
  }

  @override
  bool isReadySync<T extends Object>({Object? instance, String? instanceName}) =>
      _getIt.isReadySync<T>(instance: instance, instanceName: instanceName);

  @override
  void registerLazySingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    DisposableFunc<T>? dispose,
  }) {
    assert(
      !_getIt.isRegistered<T>(instanceName: instanceName),
      'Type $T with instance name $instanceName is already registered',
    );
    _getIt.registerLazySingletonAsync<T>(factoryFunc, instanceName: instanceName, dispose: dispose);
  }

  @override
  Future<void> isReady<T extends Object>({
    Object? instance,
    String? instanceName,
    Duration? timeout,
    Object? callee,
  }) async {
    await _getIt.isReady<T>(instance: instance, instanceName: instanceName, timeout: timeout, callee: callee);
  }

  @override
  Future<void> allReady({Duration? timeout, bool ignorePendingAsyncCreation = false}) async {
    await _getIt.allReady(timeout: timeout, ignorePendingAsyncCreation: ignorePendingAsyncCreation);
  }
}
