import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_methods/platform_methods.dart';
import 'package:platform_methods/platform_methods_method_channel.dart';
import 'package:platform_methods/platform_methods_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPlatformMethodsPlatform extends Mock with MockPlatformInterfaceMixin implements PlatformMethodsPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformMethods', () {
    final PlatformMethodsPlatform initialPlatform = PlatformMethodsPlatform.instance;

    setUp(() {
      // Har bir testdan oldin default platformga qaytaramiz
      PlatformMethodsPlatform.instance = initialPlatform;
    });

    tearDown(() {
      // Har bir testdan keyin ham kafolat uchun tiklaymiz
      PlatformMethodsPlatform.instance = initialPlatform;
    });

    test('$MethodChannelPlatformMethods is the default instance', () {
      expect(initialPlatform, isA<MethodChannelPlatformMethods>());
    });

    test('instance should be singleton', () {
      final instance1 = PlatformMethods.instance;
      final instance2 = PlatformMethods.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    group('getId', () {
      test('should return mocked device ID', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.getDeviceId).thenAnswer((_) async => 'mocked_id');

        PlatformMethodsPlatform.instance = mock;

        final result = await platformMethodsPlugin.getDeviceId();
        expect(result, equals('mocked_id'));

        verify(mock.getDeviceId).called(1);
      });

      test('should handle platform errors', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.getDeviceId).thenThrow(Exception('GetId error'));

        PlatformMethodsPlatform.instance = mock;

        expect(platformMethodsPlugin.getDeviceId, throwsA(isA<Exception>()));

        verify(mock.getDeviceId).called(1);
      });

      test('should return null when platform returns null', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.getDeviceId).thenAnswer((_) async => null);

        PlatformMethodsPlatform.instance = mock;

        final result = await platformMethodsPlugin.getDeviceId();
        expect(result, isNull);

        verify(mock.getDeviceId).called(1);
      });
    });

    group('isPhysicalDevice', () {
      test('should return false for emulator', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.isPhysicalDevice).thenAnswer((_) async => false);

        PlatformMethodsPlatform.instance = mock;

        final result = await platformMethodsPlugin.isPhysicalDevice();
        expect(result, isFalse);

        verify(mock.isPhysicalDevice).called(1);
      });

      test('should return true for physical device', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.isPhysicalDevice).thenAnswer((_) async => true);

        PlatformMethodsPlatform.instance = mock;

        final result = await platformMethodsPlugin.isPhysicalDevice();
        expect(result, isTrue);

        verify(mock.isPhysicalDevice).called(1);
      });

      test('should handle platform errors', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.isPhysicalDevice).thenThrow(Exception('Platform error'));

        PlatformMethodsPlatform.instance = mock;

        expect(platformMethodsPlugin.isPhysicalDevice, throwsA(isA<Exception>()));

        verify(mock.isPhysicalDevice).called(1);
      });

      test('should return null when platform returns null', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.isPhysicalDevice).thenAnswer((_) async => null);

        PlatformMethodsPlatform.instance = mock;

        final result = await platformMethodsPlugin.isPhysicalDevice();
        expect(result, isNull);

        verify(mock.isPhysicalDevice).called(1);
      });
    });

    group('cancel', () {
      test('should call cancel method', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.cancel).thenAnswer((_) async {});

        PlatformMethodsPlatform.instance = mock;

        await platformMethodsPlugin.cancel();

        verify(mock.cancel).called(1);
      });

      test('should handle platform errors', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(mock.cancel).thenThrow(Exception('Cancel error'));

        PlatformMethodsPlatform.instance = mock;

        expect(platformMethodsPlugin.cancel, throwsA(isA<Exception>()));

        verify(mock.cancel).called(1);
      });
    });
  });
}
