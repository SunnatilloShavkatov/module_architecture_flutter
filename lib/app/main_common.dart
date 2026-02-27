import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app/app.dart';

Future<void> mainCommon({required Environment env, required FirebaseOptions options}) async {
  /// 1. Initialize Flutter and Environment
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  MergeDependencies.initEnvironment(env: env);
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  /// 2. Global Error Handling (Modern Approach)
  _setupErrorHandling();

  /// 3. Notification Service
  /// Starts early to catch launch notifications.
  NotificationService.instance.initialize(options).ignore();

  /// 4. Parallel Initialization (Dependency Injection)
  /// Registering modules is critical for other services.
  await MergeDependencies.instance.registerModules();

  /// 5. Non-Critical Background setup (Fire and forget where safe)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// 6. Bloc Observer Configuration
  _setupBlocObserver();

  /// 7. UI Optimization: Set orientations and UI mode early
  _configureSystemUI();

  /// 8. Run App
  runApp(
    ModelBinding(
      key: const Key('modelBinding'),
      initialModel: AppOptions(
        themeMode: AppInjector.instance.get<LocalSource>().themeMode,
        locale: Locale(AppInjector.instance.get<LocalSource>().locale ?? defaultLocale),
      ),
      child: const App(key: Key('app')),
    ),
  );

  /// 9. Final touches after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) => FlutterNativeSplash.remove());
}

void _setupErrorHandling() {
  FlutterError.onError = (errorDetails) {
    logMessage('widget error: $errorDetails', stackTrace: errorDetails.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logMessage('platform dispatcher error: $error', stackTrace: stack);
    return true;
  };
}

void _setupBlocObserver() {
  if (kDebugMode) {
    Bloc.observer = MultiBlocObserver(observers: [PerformanceBlocObserver(), const LoggingBlocObserver()]);
  } else if (kProfileMode) {
    Bloc.observer = PerformanceBlocObserver();
  }
}

void _configureSystemUI() {
  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      if (mediaView.size.isTablet) ...[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    ]),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]),
  ]).ignore();
}
