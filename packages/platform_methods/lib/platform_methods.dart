import 'package:platform_methods/platform_methods_platform_interface.dart';

class PlatformMethods {
  const PlatformMethods._();

  static PlatformMethods get instance => _instance;
  static const PlatformMethods _instance = PlatformMethods._();

  Future<String?> getDeviceId() => PlatformMethodsPlatform.instance.getDeviceId();

  Future<bool?> isPhysicalDevice() => PlatformMethodsPlatform.instance.isPhysicalDevice();
}
