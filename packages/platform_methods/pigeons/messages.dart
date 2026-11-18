import 'package:pigeon/pigeon.dart';

// Native Interop (FFI on iOS, JNI on Android) — no platform channels.
// Regenerate with: dart run pigeon --input pigeons/messages.dart
// (build the example app for Android and iOS first so JNIgen/FFIgen can
// find the compiled Kotlin classes and Swift module).
@ConfigurePigeon(
  PigeonOptions(
    appDirectory: 'example/',
    // Generated tool/pigeon/*_config.dart run with cwd = package root, so
    // their paths must be relative to it, not to the example app.
    configDirectory: './',
    dartOut: 'lib/src/messages.g.dart',
    dartOptions: DartOptions(),
    dartPackageName: 'platform_methods',
    kotlinOut: 'android/src/main/kotlin/uz/plugin/platform_methods/Messages.g.kt',
    kotlinOptions: KotlinOptions(
      appDirectory: 'example/',
      errorClassName: 'PlatformMethodsError',
      package: 'uz.plugin.platform_methods',
      useJni: true,
    ),
    swiftOut: 'ios/platform_methods/Sources/platform_methods/Messages.g.swift',
    swiftOptions: SwiftOptions(
      appDirectory: 'example/',
      errorClassName: 'PlatformMethodsError',
      ffiModuleName: 'platform_methods',
      useFfi: true,
    ),
  ),
)
@HostApi()
abstract class PlatformMethodsHostApi {
  @async
  bool isEmulator();

  @async
  String? getDeviceId();

  @async
  bool isReviewAvailable();

  @async
  void requestReview();

  @async
  void openStoreListing(String? appStoreId);
}
