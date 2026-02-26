import 'package:platform_methods/platform_methods_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PlatformMethodsPlatform extends PlatformInterface {
  /// Constructs a PlatformMethodsPlatform.
  PlatformMethodsPlatform() : super(token: _token);

  static final Object _token = Object();

  static PlatformMethodsPlatform _instance = MethodChannelPlatformMethods();

  /// The default instance of [PlatformMethodsPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformMethods].
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
}
