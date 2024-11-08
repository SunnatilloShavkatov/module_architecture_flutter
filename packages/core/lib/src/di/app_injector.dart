import "package:base_dependencies/base_dependencies.dart";
import "package:core/src/di/injector.dart";

class AppInjector implements Injector {
  AppInjector._();

  final GetIt _getIt = GetIt.instance;

  static Injector? _internal;

  static Injector get instance => _instance;

  static Injector get _instance {
    _internal ??= AppInjector._();
    return _internal!;
  }

  @override
  void registerLazySingleton<T extends Object>(T Function() function, {String? instanceName}) {
    if (!_getIt.isRegistered<T>(instanceName: instanceName)) {
      _getIt.registerLazySingleton<T>(
        () => function.call(),
        instanceName: instanceName,
      );
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
  Future<void> registerSingletonAsync<T extends Object>(
    AsyncFunc<T> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposableFunc<T>? dispose,
  }) async {
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
}
