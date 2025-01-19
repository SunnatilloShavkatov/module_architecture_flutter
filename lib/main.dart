import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_flutter/app.dart';

Future<void> main() async {
  /// init environment
  Merge.initEnvironment(env: Environment.prod);

  /// flutter_native_splash
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Future.wait(
    <Future<void>>[
      /// set orientation
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]),
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: <SystemUiOverlay>[SystemUiOverlay.top, SystemUiOverlay.bottom],
      ),

      /// notification initialize
      // NotificationService.initialize(DefaultFirebaseOptions.currentPlatform),

      /// di initialize
      Merge.registerModules(),
    ],
  );

  /// bloc logger
  if (kDebugMode) {
    Bloc.observer = LogBlocObserver();
  }

  /// global CERTIFICATE_VERIFY_FAILEd_KEY
  HttpOverrides.global = _HttpOverrides();
  runApp(
    ModelBinding(
      initialModel: AppOptions(
        themeMode: ThemeMode.light,
        locale: Locale(localSource.locale),
      ),
      child: const App(),
    ),
  );
  FlutterNativeSplash.remove();
}

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)..badCertificateCallback = (_, __, ___) => true;
}
