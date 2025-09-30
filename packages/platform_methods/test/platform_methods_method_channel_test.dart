import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_methods/platform_methods_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelPlatformMethods platform = MethodChannelPlatformMethods();
  const MethodChannel channel = MethodChannel('platform_methods');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      MethodCall methodCall,
    ) async {
      switch (methodCall.method) {
        case 'getDeviceId':
          return 'test_device_id_12345';
        case 'isPhysicalDevice':
          return true;
        case 'vibrate':
          return null;
        case 'cancel':
          return null;
        default:
          throw PlatformException(code: 'UNIMPLEMENTED', message: 'Method ${methodCall.method} not implemented');
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('MethodChannelPlatformMethods', () {
    group('getDeviceId', () {
      test('should return device ID on native platforms', () async {
        final result = await platform.getDeviceId();
        expect(result, equals('test_device_id_12345'));
      });

      test('should handle platform exceptions', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'getDeviceId') {
            throw PlatformException(code: 'UNAVAILABLE', message: 'Device ID not available');
          }
          return null;
        });

        expect(platform.getDeviceId, throwsA(isA<PlatformException>()));
      });
    });

    group('isPhysicalDevice', () {
      test('should return true for physical device', () async {
        final result = await platform.isPhysicalDevice();
        expect(result, isTrue);
      });

      test('should return false for emulator', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'isPhysicalDevice') {
            return false;
          }
          return null;
        });

        final result = await platform.isPhysicalDevice();
        expect(result, isFalse);
      });

      test('should handle platform exceptions', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'isPhysicalDevice') {
            throw PlatformException(code: 'UNAVAILABLE', message: 'Device info not available');
          }
          return null;
        });

        expect(platform.isPhysicalDevice, throwsA(isA<PlatformException>()));
      });
    });

    group('cancel', () {
      test('should close code stream', () async {
        final doneExpectation = expectLater(platform.code, emitsDone);
        await platform.cancel();
        await doneExpectation;
      });

      test('should not throw', () async {
        await platform.cancel();
      });
    });

    group('method channel integration', () {
      test('should use correct method channel name', () {
        expect(platform.methodChannel.name, equals('platform_methods'));
      });

      test('should handle unknown method calls', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          throw PlatformException(code: 'UNIMPLEMENTED', message: 'Method ${methodCall.method} not implemented');
        });

        expect(platform.getDeviceId, throwsA(isA<PlatformException>()));
      });
    });
  });
}
