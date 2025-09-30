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

    group('vibrate', () {
      test('should call vibrate with default parameters', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).thenAnswer((_) async {});

        PlatformMethodsPlatform.instance = mock;

        await platformMethodsPlugin.vibrate();

        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);
      });

      test('should call vibrate with custom parameters', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).thenAnswer((_) async {});

        PlatformMethodsPlatform.instance = mock;

        const customDuration = 1000;
        const customPattern = [0, 200, 100, 200];
        const customRepeat = 2;
        const customAmplitude = 255;
        const customIntensities = [0, 255, 0, 255];

        await platformMethodsPlugin.vibrate(
          duration: customDuration,
          pattern: customPattern,
          repeat: customRepeat,
          amplitude: customAmplitude,
          intensities: customIntensities,
        );

        verify(
          () => mock.vibrate(
            duration: customDuration,
            pattern: any(named: 'pattern', that: equals(customPattern)),
            repeat: customRepeat,
            amplitude: customAmplitude,
            intensities: any(named: 'intensities', that: equals(customIntensities)),
          ),
        ).called(1);
      });

      test('should handle platform errors', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).thenThrow(Exception('Vibrate error'));

        PlatformMethodsPlatform.instance = mock;

        expect(platformMethodsPlugin.vibrate, throwsA(isA<Exception>()));

        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);
      });

      test('should handle different parameter combinations', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).thenAnswer((_) async {});

        PlatformMethodsPlatform.instance = mock;

        // only duration
        await platformMethodsPlugin.vibrate(duration: 200);
        verify(
          () => mock.vibrate(
            duration: 200,
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);

        // only pattern
        await platformMethodsPlugin.vibrate(pattern: const [100, 200]);
        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern', that: equals(const [100, 200])),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);

        // only repeat
        await platformMethodsPlugin.vibrate(repeat: 1);
        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: 1,
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);

        // only amplitude
        await platformMethodsPlugin.vibrate(amplitude: 128);
        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: 128,
          ),
        ).called(1);

        // only intensities
        await platformMethodsPlugin.vibrate(intensities: const [255, 0]);
        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities', that: equals(const [255, 0])),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);
      });

      test('should handle edge cases', () async {
        final PlatformMethods platformMethodsPlugin = PlatformMethods.instance;
        final mock = MockPlatformMethodsPlatform();

        when(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).thenAnswer((_) async {});

        PlatformMethodsPlatform.instance = mock;

        // zero duration
        await platformMethodsPlugin.vibrate(duration: 0);
        verify(
          () => mock.vibrate(
            duration: 0,
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);

        // negative duration
        await platformMethodsPlugin.vibrate(duration: -100);
        verify(
          () => mock.vibrate(
            duration: -100,
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);

        // empty pattern
        await platformMethodsPlugin.vibrate();
        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern', that: isEmpty),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities'),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);

        // empty intensities
        await platformMethodsPlugin.vibrate();
        verify(
          () => mock.vibrate(
            duration: any(named: 'duration'),
            pattern: any(named: 'pattern'),
            repeat: any(named: 'repeat'),
            intensities: any(named: 'intensities', that: isEmpty),
            amplitude: any(named: 'amplitude'),
          ),
        ).called(1);
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
