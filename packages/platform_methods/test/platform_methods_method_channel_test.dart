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

    group('vibrate', () {
      test('should call vibrate with default parameters', () async {
        bool vibrateCalled = false;
        Map<String, Object>? callArguments;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'vibrate') {
            vibrateCalled = true;
            callArguments = Map<String, Object>.from(methodCall.arguments);
          }
          return null;
        });

        await platform.vibrate();

        expect(vibrateCalled, isTrue);
        expect(callArguments, isNotNull);
        expect(callArguments!['duration'], equals(500));
        expect(callArguments!['pattern'], equals(<int>[]));
        expect(callArguments!['repeat'], equals(-1));
        expect(callArguments!['amplitude'], equals(-1));
        expect(callArguments!['intensities'], equals(<int>[]));
      });

      test('should call vibrate with custom parameters', () async {
        bool vibrateCalled = false;
        Map<String, Object>? callArguments;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'vibrate') {
            vibrateCalled = true;
            callArguments = Map<String, Object>.from(methodCall.arguments);
          }
          return null;
        });

        const customDuration = 1000;
        const customPattern = [0, 200, 100, 200];
        const customRepeat = 2;
        const customAmplitude = 255;
        const customIntensities = [0, 255, 0, 255];

        await platform.vibrate(
          duration: customDuration,
          pattern: customPattern,
          repeat: customRepeat,
          amplitude: customAmplitude,
          intensities: customIntensities,
        );

        expect(vibrateCalled, isTrue);
        expect(callArguments, isNotNull);
        expect(callArguments!['duration'], equals(customDuration));
        expect(callArguments!['pattern'], equals(customPattern));
        expect(callArguments!['repeat'], equals(customRepeat));
        expect(callArguments!['amplitude'], equals(customAmplitude));
        expect(callArguments!['intensities'], equals(customIntensities));
      });

      test('should handle platform exceptions', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'vibrate') {
            throw PlatformException(code: 'UNAVAILABLE', message: 'Vibration not available');
          }
          return null;
        });

        expect(platform.vibrate, throwsA(isA<PlatformException>()));
      });

      test('should handle different parameter combinations', () async {
        // Test with only duration
        await platform.vibrate(duration: 200);

        // Test with only pattern
        await platform.vibrate(pattern: [100, 200]);

        // Test with only repeat
        await platform.vibrate(repeat: 1);

        // Test with only amplitude
        await platform.vibrate(amplitude: 128);

        // Test with only intensities
        await platform.vibrate(intensities: [255, 0]);

        // All should complete without throwing
        expect(true, isTrue);
      });
    });

    group('cancel', () {
      test('should call cancel method', () async {
        bool cancelCalled = false;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'cancel') {
            cancelCalled = true;
          }
          return null;
        });

        await platform.cancel();

        expect(cancelCalled, isTrue);
      });

      test('should handle platform exceptions', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'cancel') {
            throw PlatformException(code: 'UNAVAILABLE', message: 'Cancel not available');
          }
          return null;
        });

        expect(platform.cancel, throwsA(isA<PlatformException>()));
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
