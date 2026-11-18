import 'package:platform_methods/src/platform_methods_native_interop.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PlatformMethodsPlatform extends PlatformInterface {
  /// Constructs a PlatformMethodsPlatform.
  new() : super(token: _token);

  static final Object _token = Object();

  static PlatformMethodsPlatform _instance = NativeInteropPlatformMethods();

  /// The default instance of [PlatformMethodsPlatform] to use.
  ///
  /// Defaults to [NativeInteropPlatformMethods].
  static PlatformMethodsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformMethodsPlatform] when
  /// they register themselves.
  static set instance(PlatformMethodsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isEmulator() {
    throw UnimplementedError('isEmulator() has not been implemented.');
  }

  Future<String?> getDeviceId() {
    throw UnimplementedError('getId() has not been implemented.');
  }

  Future<bool> isReviewAvailable() {
    throw UnimplementedError('isReviewAvailable() has not been implemented.');
  }

  Future<void> requestReview() {
    throw UnimplementedError('requestReview() has not been implemented.');
  }

  Future<void> openStoreListing({String? appStoreId}) {
    throw UnimplementedError('openStoreListing() has not been implemented.');
  }
}
