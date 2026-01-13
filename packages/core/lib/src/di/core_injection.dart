import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/src/connectivity/network_info.dart';
import 'package:core/src/core_abstractions/injection.dart';
import 'package:core/src/core_abstractions/injector.dart';
import 'package:core/src/di/app_injector.dart';
import 'package:core/src/dio_retry/retry_interceptor.dart';
import 'package:core/src/local_source/local_source.dart';
import 'package:core/src/network/network_provider.dart';
import 'package:core/src/retriever/sms_retriever_impl.dart';
import 'package:core/src/services/app_navigation_service.dart';
import 'package:core/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pinput/flutter_pinput.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_auth/smart_auth.dart';

final class CoreInjection implements Injection {
  const CoreInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) async {
    /// External
    await _initHive(di: di);
    di
      ..registerLazySingleton<Injector>(() => AppInjector.instance)
      ..registerLazySingleton(
        () => Dio()
          ..options = BaseOptions(
            followRedirects: false,
            contentType: 'application/json',
            sendTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 25),
            connectTimeout: const Duration(seconds: 30),
          )
          ..httpClientAdapter = IOHttpClientAdapter(
            createHttpClient: () =>
                HttpClient(context: SecurityContext(withTrustedRoots: true))
                  ..badCertificateCallback = (_, _, _) => false,
          )
          ..interceptors.addAll(<Interceptor>[
            if (kDebugMode)
              LogInterceptor(
                requestBody: true,
                responseBody: true,
                logPrint: (object) {
                  logMessage('dio: $object');
                },
              ),
          ]),
      )
      ..registerLazySingleton<Connectivity>(Connectivity.new)
      ..registerLazySingleton(InternetConnectionChecker.createInstance)
      ..registerSingletonAsync<PackageInfo>(PackageInfo.fromPlatform)
      ..registerLazySingleton<SmartAuth>(() => SmartAuth.instance)
      ..registerLazySingleton<SmsRetriever>(() => SmsRetrieverImpl(di.get()))
      ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di.get()));

    di.get<Dio>().interceptors.addAll(<Interceptor>[
      RetryInterceptor(
        dio: di.get<Dio>(),
        toNoInternetPageNavigator: () async {
          final nav = di.get<AppNavigationService>();
          if (nav.isCurrentPath('/no-internet')) {
            return;
          }
          nav.navigateToNoInternet();
        },
        accessTokenGetter: () => di.get<LocalSource>().accessToken ?? '',
        forbiddenFunction: () async {},
        refreshTokenFunction: () => _onLogout(di),
        logPrint: (String message) {
          logMessage('dio: $message');
        },
      ),
    ]);
    di.registerLazySingleton<NetworkProvider>(() => NetworkProviderImpl(di.get<Dio>(), di.get<LocalSource>()));
  }
}

Future<void> _initHive({required Injector di}) async {
  /// init shared preferences
  final SharedPreferencesWithCache prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  /// init hive
  const String boxName = 'module_architecture_mobile_box';
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  final Box<dynamic> box = await Hive.openBox<dynamic>(boxName);
  final Box<dynamic> cacheBox = await Hive.openBox<dynamic>('cache_$boxName');
  di.registerSingleton<LocalSource>(LocalSourceImpl(box, cacheBox, prefs));
}

Future<void> _onLogout(Injector di) async {
  try {
    await Future.wait(<Future<void>>[
      // FirebaseAuth.instance.signOut(),
      // FirebaseSubscriptions.instance.unsubscribeFromAllTopics(),
    ]).timeout(const Duration(seconds: 5), onTimeout: () => throw TimeoutException('Timeout Exception 5 seconds'));
  } on Exception catch (e, s) {
    logMessage('Error: ', error: e, stackTrace: s);
  }
  await di.get<LocalSource>().clear();
  final nav = di.get<AppNavigationService>();
  if (nav.isCurrentPath('/')) {
    return;
  }
  nav.navigateToInitial();
}
