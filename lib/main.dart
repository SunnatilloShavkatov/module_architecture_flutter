import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app.dart';
import 'package:module_architecture_mobile/firebase_options.dart';

Future<void> main() async {
  /// 1. Initialize Flutter and Environment
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  MergeDependencies.initEnvironment(env: Environment.prod);
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  /// 2. Global Error Handling (Modern Approach)
  _setupErrorHandling();

  /// 3. Parallel Initialization
  /// Firebase and DI are the heaviest tasks. Running them together is more efficient.
  await Future.wait([
    NotificationService.instance.initializeApp(DefaultFirebaseOptions.currentPlatform),
    MergeDependencies.instance.registerModules(),
  ]);

  /// 4. Non-Critical Background setup (Fire and forget where safe)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// 5. App Metrica Initialization and Notification Service
  NotificationService.instance.initialize();

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
  // Catch Flutter-specific errors (widget tree, etc)
  FlutterError.onError = (errorDetails) {
    logMessage('widget error: $errorDetails', stackTrace: errorDetails.stack);
  };

  // Catch all other asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    logMessage('platform dispatcher error: $error', stackTrace: stack);
    return true;
  };
}

void _setupBlocObserver() {
  /// Bloc observer registration
  ///
  /// - Debug mode: Full logging + performance monitoring
  /// - Profile mode: Performance monitoring only (for profiling)
  /// - Release mode: No observers (production)
  ///
  /// Observer order matters: PerformanceBlocObserver must run first to start timers
  /// before LoggingBlocObserver logs the events.
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
