import "package:base_dependencies/base_dependencies.dart";
import "package:core/src/core_abstractions/injector.dart";
import "package:flutter/foundation.dart";

@protected
final GetIt _getIt = GetIt.instance;

class AppInjector implements Injector {
  const AppInjector._();

  static const Injector instance = AppInjector._();

  @override
  void registerLazySingleton<T extends Object>(T Function() function, {String? instanceName}) {
    if (!_getIt.isRegistered<T>(instanceName: instanceName)) {
      _getIt.registerLazySingleton<T>(() => function.call(), instanceName: instanceName);
    }
  }

  @override
  void registerSingleton<T extends Object>(T instance, {String? instanceName}) {
    if (!_getIt.isRegistered<T>(instanceName: instanceName)) {
      _getIt.registerSingleton<T>(instance, instanceName: instanceName);
    }
  }

  @override
  T get<T extends Object>({String? instanceName}) => _getIt.get<T>(instanceName: instanceName);

  @override
  Future<void> unregister<T extends Object>() async => _getIt.unregister<T>();

  @override
  void registerFactory<T extends Object>(T Function() function) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerFactory<T>(() => function.call());
    }
  }

  @override
  void registerSingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposableFunc<T>? dispose,
  }) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingletonAsync<T>(
        factoryFunc,
        instanceName: instanceName,
        dependsOn: dependsOn,
        signalsReady: signalsReady,
        dispose: dispose,
      );
    }
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
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerLazySingletonAsync<T>(factoryFunc, instanceName: instanceName, dispose: dispose);
    }
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
