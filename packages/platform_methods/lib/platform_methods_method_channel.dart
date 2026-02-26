import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:platform_methods/platform_methods_platform_interface.dart';

/// An implementation of [PlatformMethodsPlatform] that uses method channels.
class MethodChannelPlatformMethods extends PlatformMethodsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('platform_methods');

  /// Calls the native method to retrieve the Android ID.
  @override
  Future<String?> getDeviceId() async {
    if (kIsWeb) {
      return null;
    }
    return methodChannel.invokeMethod<String?>('getDeviceId');
  }

  @override
  Future<bool> isEmulator() async {
    if (kIsWeb) {
      return false;
    }
    return await methodChannel.invokeMethod<bool?>('isEmulator') ?? false;
  }
}
