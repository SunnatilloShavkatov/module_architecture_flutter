import 'dart:async';
import 'dart:convert' show base64Decode, base64Encode;
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/src/connectivity/network_info.dart';
import 'package:core/src/constants/env.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_auth/smart_auth.dart';

final class CoreInjection implements Injection {
  const CoreInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) async {
    /// External
    await _initStorage(di: di);
    final String? accessToken = await di.get<LocalSource>().accessToken;
    di
      ..registerLazySingleton<Injector>(() => AppInjector.instance)
      ..registerLazySingleton(
        () => Dio()
          ..options = BaseOptions(
            baseUrl: AppEnvironment.instance.config.baseUrl,
            followRedirects: false,
            contentType: 'application/json',
            sendTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 25),
            connectTimeout: const Duration(seconds: 30),
            headers: <String, dynamic>{
              'api-token': AppEnvironment.instance.config.apiToken,
              if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            },
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
      ..registerLazySingleton<SmartAuth>(() => SmartAuth.instance)
      ..registerLazySingleton(InternetConnectionChecker.createInstance)
      ..registerLazySingletonAsync<PackageInfo>(PackageInfo.fromPlatform)
      ..registerLazySingleton<SmsRetriever>(() => SmsRetrieverImpl(di.get()))
      ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di.get()));

    di.get<Dio>().interceptors.addAll(<Interceptor>[
      RetryInterceptor(
        dio: di.get<Dio>(),
        accessTokenGetter: () async => await di.get<LocalSource>().accessToken ?? '',
        toNoInternetPageNavigator: di.get<AppNavigationService>().navigateToNoInternet,
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

Future<void> _initStorage({required Injector di}) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  try {
    final Uint8List hiveKey = await _getOrCreateHiveKey(storage);
    final HiveAesCipher cipher = HiveAesCipher(hiveKey);

    /// init hive
    const String boxName = 'module_architecture_mobile_box';
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    final List<Box<dynamic>> boxes = await Future.wait([
      Hive.openBox<dynamic>(boxName, encryptionCipher: cipher),
      Hive.openBox<dynamic>('cache_$boxName', encryptionCipher: cipher),
    ]);
    di.registerSingleton<LocalSource>(LocalSourceImpl(boxes[0], boxes[1], storage));
  } catch (e, s) {
    logMessage('Failed init Storage', error: e, stackTrace: s);
  }
}

Future<Uint8List> _getOrCreateHiveKey(FlutterSecureStorage storage) async {
  try {
    final String? storedKey = await storage.read(key: 'hive_key');

    if (storedKey != null && storedKey.isNotEmpty) {
      return base64Decode(storedKey);
    }

    final Random secureRandom = Random.secure();
    final Uint8List keyBytes = Uint8List(32);
    for (var i = 0; i < keyBytes.length; i++) {
      keyBytes[i] = secureRandom.nextInt(256);
    }

    await storage.write(key: 'hive_key', value: base64Encode(keyBytes));

    return keyBytes;
  } catch (e, s) {
    logMessage('Failed to generate or read Hive encryption key', error: e, stackTrace: s);
    throw StateError('Failed to generate or read Hive encryption key');
  }
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
