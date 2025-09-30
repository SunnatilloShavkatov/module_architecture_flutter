import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_methods/platform_methods.dart';
import 'package:platform_methods/platform_methods_method_channel.dart';
import 'package:platform_methods/platform_methods_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockPlatform extends Mock with MockPlatformInterfaceMixin implements PlatformMethodsPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformMethods additional', () {
    final PlatformMethodsPlatform initial = PlatformMethodsPlatform.instance;

    setUp(() {
      PlatformMethodsPlatform.instance = initial;
    });

    tearDown(() {
      PlatformMethodsPlatform.instance = initial;
      debugDefaultTargetPlatformOverride = null;
    });

    group('Facade delegates', () {
      test('getAppSignature delegates to platform implementation', () async {
        final mock = _MockPlatform();
        when(() => mock.getAppSignature).thenAnswer((_) async => 'sig');
        PlatformMethodsPlatform.instance = mock;

        final result = await PlatformMethods.instance.getAppSignature;
        expect(result, 'sig');
        verify(() => mock.getAppSignature).called(1);
      });

      test('unregisterListener delegates to platform implementation', () async {
        final mock = _MockPlatform();
        when(mock.unregisterListener).thenAnswer((_) async {});
        PlatformMethodsPlatform.instance = mock;

        await PlatformMethods.instance.unregisterListener();
        verify(mock.unregisterListener).called(1);
      });

      test('listenForCode delegates with provided pattern', () async {
        final mock = _MockPlatform();
        when(() => mock.listenForCode(smsCodeRegexPattern: any(named: 'smsCodeRegexPattern'))).thenAnswer((_) async {});
        PlatformMethodsPlatform.instance = mock;

        await PlatformMethods.instance.listenForCode(smsCodeRegexPattern: r'\d{4}');
        verify(() => mock.listenForCode(smsCodeRegexPattern: r'\d{4}')).called(1);
      });

      test('code stream is proxied', () async {
        final controller = StreamController<String>.broadcast(sync: true);
        addTearDown(controller.close);

        final mock = _MockPlatform();
        when(() => mock.code).thenAnswer((_) => controller.stream);
        PlatformMethodsPlatform.instance = mock;

        final completer = Completer<String>();
        final sub = PlatformMethods.instance.code.listen((value) {
          if (!completer.isCompleted) {
            completer.complete(value);
          }
        });
        addTearDown(sub.cancel);

        controller.add('123456');
        final value = await completer.future;
        expect(value, '123456');
      });
    });

    group('MethodChannelPlatformMethods platform gating', () {
      const MethodChannel channel = MethodChannel('platform_methods');

      test('getAppSignature returns null on non-Android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        final impl = MethodChannelPlatformMethods();
        final result = await impl.getAppSignature;
        expect(result, isNull);
      });

      test('getAppSignature returns value on Android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final impl = MethodChannelPlatformMethods();

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall call,
        ) async {
          if (call.method == 'getAppSignature') {
            return 'app_sig_abc';
          }
          return null;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
        });

        final result = await impl.getAppSignature;
        expect(result, 'app_sig_abc');
      });

      test('unregisterListener is no-op on iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        final impl = MethodChannelPlatformMethods();

        // If channel is invoked on iOS, throw to fail the test
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall call,
        ) async {
          if (call.method == 'unregisterListener') {
            throw StateError('Should not be called on iOS');
          }
          return null;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
        });

        await impl.unregisterListener();
      });

      test('unregisterListener invokes native on Android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final impl = MethodChannelPlatformMethods();
        bool called = false;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall call,
        ) async {
          if (call.method == 'unregisterListener') {
            called = true;
          }
          return null;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
        });

        await impl.unregisterListener();
        expect(called, isTrue);
      });

      test('listenForCode sends pattern on Android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final impl = MethodChannelPlatformMethods();
        Map<String, String>? args;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall call,
        ) async {
          if (call.method == 'listenForCode') {
            args = (call.arguments as Map).cast<String, String>();
          }
          return null;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
        });

        await impl.listenForCode(smsCodeRegexPattern: r'\d{6}');
        expect(args, isNotNull);
        expect(args!['smsCodeRegexPattern'], r'\d{6}');
      });

      test('listenForCode is no-op on iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        final impl = MethodChannelPlatformMethods();

        // Fail if called
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          MethodCall call,
        ) async {
          if (call.method == 'listenForCode') {
            throw StateError('Should not be called on iOS');
          }
          return null;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
        });

        await impl.listenForCode(smsCodeRegexPattern: r'\d{6}');
      });

      test('code stream emits when smscode method arrives', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final impl = MethodChannelPlatformMethods();

        // Expect the next item from the code stream
        final expectation = expectLater(impl.code, emits('654321'));

        // Simulate a platform-to-dart callback invoking the setMethodCallHandler
        const codec = StandardMethodCodec();
        final data = codec.encodeMethodCall(const MethodCall('smscode', '654321'));
        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
          'platform_methods',
          data,
          (ByteData? _) {},
        );

        await expectation;
      });

      test('cancel closes code stream', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final impl = MethodChannelPlatformMethods();

        // After cancel, the stream should complete
        final doneExpectation = expectLater(impl.code, emitsDone);
        await impl.cancel();
        await doneExpectation;
      });
    });
  });
}
