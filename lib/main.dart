import "dart:io";

import "package:base_dependencies/base_dependencies.dart";
import "package:core/core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:module_architecture_flutter/app.dart";
import "package:module_architecture_flutter/di/injector_container.dart";

Future<void> main() async {
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
      // NotificationService.initialize(),

      /// di initialize
      initDI(),
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
        locale: Locale(AppInjector.instance.get<LocalSource>().locale),
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
