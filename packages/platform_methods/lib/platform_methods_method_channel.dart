import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:platform_methods/platform_methods_platform_interface.dart';

/// An implementation of [PlatformMethodsPlatform] that uses method channels.
class MethodChannelPlatformMethods extends PlatformMethodsPlatform {
  MethodChannelPlatformMethods() {
    methodChannel.setMethodCallHandler(_didReceive);
  }

  final StreamController<String> _code = StreamController.broadcast();

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('platform_methods');

  Future<void> _didReceive(MethodCall method) async {
    if (method.method == 'smscode') {
      _code.add(method.arguments.toString());
    }
  }

  @override
  Stream<String> get code => _code.stream;

  /// Calls the native method to retrieve the Android ID.
  @override
  Future<String?> getDeviceId() async {
    if (kIsWeb) {
      return null;
    }
    return methodChannel.invokeMethod<String?>('getDeviceId');
  }

  @override
  Future<bool?> isPhysicalDevice() async {
    if (kIsWeb) {
      return null;
    }
    return methodChannel.invokeMethod<bool?>('isPhysicalDevice');
  }

  @override
  Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const <int>[],
    int repeat = -1,
    List<int> intensities = const <int>[],
    int amplitude = -1,
  }) async {
    if (kIsWeb) {
      return;
    }
    await methodChannel.invokeMethod('vibrate', <String, dynamic>{
      'duration': duration,
      'pattern': pattern,
      'repeat': repeat,
      'intensities': intensities,
      'amplitude': amplitude,
    });
  }

  @override
  Future<String?> get getAppSignature async {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      final String? appSignature = await methodChannel.invokeMethod('getAppSignature');
      return appSignature;
    }
    return null;
  }

  @override
  Future<void> unregisterListener() async {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      await methodChannel.invokeMethod('unregisterListener');
    }
  }

  @override
  Future<void> listenForCode({required String smsCodeRegexPattern}) async {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      await methodChannel.invokeMethod('listenForCode', <String, String>{'smsCodeRegexPattern': smsCodeRegexPattern});
    }
  }

  @override
  Future<void> cancel() async {
    await _code.close();
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      await methodChannel.invokeMethod('cancel');
    }
  }
}
