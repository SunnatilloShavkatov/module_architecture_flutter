import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:platform_methods/platform_methods_platform_interface.dart';
import 'package:platform_methods/review_exception.dart';
import 'package:platform_methods/src/messages.g.dart';

/// [PlatformMethodsPlatform] backed by Pigeon Native Interop
/// (JNI on Android, FFI on iOS) — no platform channels involved.
final class NativeInteropPlatformMethods extends PlatformMethodsPlatform {
  new({@visibleForTesting PlatformMethodsHostApi? api}) : _apiOverride = api;

  final PlatformMethodsHostApi? _apiOverride;

  // Lazy: creating the interop API eagerly can run before JNI is initialized.
  late final PlatformMethodsHostApi _api = _apiOverride ?? PlatformMethodsHostApi.createWithNativeInteropApi();

  @override
  Future<String?> getDeviceId() async {
    if (kIsWeb) {
      return null;
    }
    return _api.getDeviceId();
  }

  @override
  Future<bool> isEmulator() async {
    if (kIsWeb) {
      return false;
    }
    return _api.isEmulator();
  }

  @override
  Future<bool> isReviewAvailable() async {
    if (kIsWeb) {
      return false;
    }
    return _guardReview(_api.isReviewAvailable);
  }

  @override
  Future<void> requestReview() async {
    if (kIsWeb) {
      return;
    }
    await _guardReview<void>(_api.requestReview);
  }

  @override
  Future<void> openStoreListing({String? appStoreId}) async {
    if (kIsWeb) {
      return;
    }
    await _guardReview<void>(() => _api.openStoreListing(appStoreId));
  }

  Future<T> _guardReview<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on PlatformException catch (e) {
      throw ReviewException(code: e.code, message: e.message ?? '', details: e.details?.toString());
    }
  }
}
