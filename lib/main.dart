import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app.dart';
import 'package:module_architecture_mobile/firebase_options.dart';

Future<void> main() async {
  /// init environment
  MergeDependencies.initEnvironment(env: Environment.prod);

  /// flutter_native_splash
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  /// set orientation, system UI mode
  await Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      if (mediaView.size.isTablet) ...[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    ]),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]),
  ]);

  /// di initialize
  await MergeDependencies.instance.registerModules();

  /// background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// notification initialize
  await NotificationService.instance.initialize(DefaultFirebaseOptions.currentPlatform);

  /// bloc logger
  if (kDebugMode) {
    Bloc.observer = LogBlocObserver();
  }

  /// global CERTIFICATE_VERIFY_FAILED_KEY
  HttpOverrides.global = _HttpOverrides();

  /// widget error
  FlutterError.onError = (errorDetails) {
    logMessage('widget error: $errorDetails ${errorDetails.stack}', stackTrace: errorDetails.stack);
  };

  /// platform dispatcher error
  PlatformDispatcher.instance.onError = (error, stack) {
    logMessage('platform dispatcher error: $error', stackTrace: stack);
    return true;
  };

  /// run app
  runApp(
    ModelBinding(
      initialModel: AppOptions(themeMode: localSource.themeMode, locale: Locale(localSource.locale ?? defaultLocale)),
      child: const App(),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)..badCertificateCallback = (_, _, _) => true;
}
