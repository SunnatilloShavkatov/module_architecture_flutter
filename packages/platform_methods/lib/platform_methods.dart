import 'package:platform_methods/platform_methods_platform_interface.dart';

export 'review_exception.dart';

class PlatformMethods {
  const PlatformMethods._();

  static PlatformMethods get instance => _instance;
  static const PlatformMethods _instance = PlatformMethods._();

  Future<bool> isEmulator() => PlatformMethodsPlatform.instance.isEmulator();

  Future<String?> getDeviceId() => PlatformMethodsPlatform.instance.getDeviceId();

  Future<bool> isReviewAvailable() => PlatformMethodsPlatform.instance.isReviewAvailable();

  Future<void> requestReview() => PlatformMethodsPlatform.instance.requestReview();

  Future<void> openStoreListing() => PlatformMethodsPlatform.instance.openStoreListing();
}
