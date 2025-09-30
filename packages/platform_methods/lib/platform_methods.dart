import 'package:platform_methods/platform_methods_platform_interface.dart';

class PlatformMethods {
  const PlatformMethods._();

  static PlatformMethods get instance => _instance;
  static const PlatformMethods _instance = PlatformMethods._();

  Future<String?> getDeviceId() => PlatformMethodsPlatform.instance.getDeviceId();

  Future<bool?> isPhysicalDevice() => PlatformMethodsPlatform.instance.isPhysicalDevice();

  Future<void> vibrate({
    int duration = 300,
    int repeat = -1,
    int amplitude = -1,
    List<int> pattern = const <int>[],
    List<int> intensities = const <int>[],
  }) => PlatformMethodsPlatform.instance.vibrate(
    repeat: repeat,
    pattern: pattern,
    duration: duration,
    amplitude: amplitude,
    intensities: intensities,
  );

  Future<String?> get getAppSignature => PlatformMethodsPlatform.instance.getAppSignature;

  Future<void> unregisterListener() => PlatformMethodsPlatform.instance.unregisterListener();

  Future<void> listenForCode({String smsCodeRegexPattern = r'\d{6}'}) =>
      PlatformMethodsPlatform.instance.listenForCode(smsCodeRegexPattern: smsCodeRegexPattern);

  Stream<String> get code => PlatformMethodsPlatform.instance.code;

  Future<void> cancel() => PlatformMethodsPlatform.instance.cancel();
}
