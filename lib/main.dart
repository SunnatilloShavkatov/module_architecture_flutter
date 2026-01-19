import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app.dart';
import 'package:module_architecture_mobile/firebase_options.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      /// init environment
      MergeDependencies.initEnvironment(env: Environment.prod);

      /// flutter_native_splash
      final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);

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
          initialModel: AppOptions(
            themeMode: AppInjector.instance.get<LocalSource>().themeMode,
            locale: Locale(AppInjector.instance.get<LocalSource>().locale ?? defaultLocale),
          ),
          child: const App(),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        /// remove splash screen
        FlutterNativeSplash.remove();

        /// set orientation, system UI mode
        await Future.wait([
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            if (mediaView.size.isTablet) ...[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
          ]),
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
          ),
        ]);
      });
    },
    (error, stackTrace) {
      logMessage('Zoned error: $error', stackTrace: stackTrace, error: error);
    },
  );
}
