import 'package:platform_methods/platform_methods_platform_interface.dart';

class PlatformMethods {
  const PlatformMethods._();

  static PlatformMethods get instance => _instance;
  static const PlatformMethods _instance = PlatformMethods._();

  Future<String?> getDeviceId() => PlatformMethodsPlatform.instance.getDeviceId();

  Future<bool?> isPhysicalDevice() => PlatformMethodsPlatform.instance.isPhysicalDevice();

  Future<String?> get getAppSignature => PlatformMethodsPlatform.instance.getAppSignature;

  Future<void> unregisterListener() => PlatformMethodsPlatform.instance.unregisterListener();

  Future<void> listenForCode({String smsCodeRegexPattern = r'\d{6}'}) =>
      PlatformMethodsPlatform.instance.listenForCode(smsCodeRegexPattern: smsCodeRegexPattern);

  Stream<String> get code => PlatformMethodsPlatform.instance.code;

  Future<void> cancel() => PlatformMethodsPlatform.instance.cancel();
}
