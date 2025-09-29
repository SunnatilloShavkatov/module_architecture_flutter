import 'dart:async';

typedef AsyncFunc<T> = Future<T> Function();
typedef DisposableFunc<T> = FutureOr<T> Function(T param);

abstract interface class Injector {
  const Injector();

  void registerLazySingleton<T extends Object>(T Function() function, {String? instanceName});

  void registerSingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposableFunc<T>? dispose,
  });

  void registerLazySingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    DisposableFunc<T>? dispose,
  });

  void registerSingleton<T extends Object>(T instance);

  void registerFactory<T extends Object>(T Function() function);

  T get<T extends Object>({String? instanceName});

  void unregister<T extends Object>();

  bool isReadySync<T extends Object>({Object? instance, String? instanceName});

  Future<void> isReady<T extends Object>({Object? instance, String? instanceName, Duration? timeout, Object? callee});

  Future<void> allReady({Duration? timeout, bool ignorePendingAsyncCreation = false});
}
