import 'dart:async';
import 'dart:io';

import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/src/connectivity/network_info.dart';
import 'package:core/src/core_abstractions/injection.dart';
import 'package:core/src/core_abstractions/injector.dart';
import 'package:core/src/di/app_injector.dart';
import 'package:core/src/dio_retry/retry_interceptor.dart';
import 'package:core/src/local_source/local_source.dart';
import 'package:core/src/network/network_provider.dart';
import 'package:core/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class CoreInjection implements Injection {
  const CoreInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) async {
    /// External
    await _initHive(di: di);
    di
      ..registerLazySingleton(
        () => Dio()
          ..options = BaseOptions(
            followRedirects: false,
            contentType: 'application/json',
            sendTimeout: const Duration(seconds: 30),
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            // headers: {'api-token': Constants.apiToken},
          )
          ..httpClientAdapter = IOHttpClientAdapter(
            createHttpClient: () => HttpClient(context: SecurityContext(withTrustedRoots: true))
              ..badCertificateCallback = (_, __, ___) => false,
          )
          ..interceptors.addAll(
            <Interceptor>[
              chuck.getDioInterceptor(),
              LogInterceptor(
                requestBody: true,
                responseBody: true,
                logPrint: (Object object) {
                  logMessage('dio: $object');
                },
              ),
            ],
          ),
      )
      ..registerLazySingleton<Connectivity>(Connectivity.new)
      ..registerLazySingleton(InternetConnectionChecker.createInstance)
      ..registerSingletonAsync<PackageInfo>(PackageInfo.fromPlatform)
      ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di.get()));

    di.get<Dio>().interceptors.addAll(
      <Interceptor>[
        RetryInterceptor(
          dio: di.get<Dio>(),
          certificateVerifyFailedFunction: () async {},
          toNoInternetPageNavigator: () async {
            if (navigatorObserver.currentRoutes.contains(Routes.noInternet)) {
              return;
            }
            await Navigator.pushNamed(rootNavigatorKey.currentContext!, Routes.noInternet);
          },
          accessTokenGetter: () => di.get<LocalSource>().accessToken,
          forbiddenFunction: () async {},
          refreshTokenFunction: _onLogout,
          logPrint: (String message) {
            logMessage('dio: $message');
          },
        ),
      ],
    );
    di.registerLazySingleton(() => NetworkProvider(di.get<Dio>()));
  }
}

Future<void> _initHive({required Injector di}) async {
  /// init hive
  const String boxName = 'module_architecture_mobile_box';
  final Directory directory = await getApplicationCacheDirectory();
  Hive.init(directory.path);
  final Box<dynamic> box = await Hive.openBox<dynamic>(boxName);
  final Box<dynamic> cacheBox = await Hive.openBox<dynamic>('cache_$boxName');
  di.registerSingleton<LocalSource>(LocalSource(box, cacheBox));
}

Future<void> _onLogout() async {
  try {
    await Future.wait(
      <Future<void>>[
        // FirebaseAuth.instance.signOut(),
        // FirebaseSubscriptions.instance.unsubscribeFromAllTopics(),
      ],
    ).timeout(const Duration(seconds: 5), onTimeout: () => throw TimeoutException('Timeout Exception 5 seconds'));
  } on Exception catch (e, s) {
    logMessage('Error: ', error: e, stackTrace: s);
  }
  await AppInjector.instance.get<LocalSource>().clear();
  if (navigatorObserver.currentRoutes.contains(Routes.splash)) {
    return;
  }
  unawaited(Navigator.pushNamedAndRemoveUntil(rootNavigatorKey.currentContext!, Routes.splash, (_) => false));
}
