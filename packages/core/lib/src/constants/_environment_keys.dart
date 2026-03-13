// ignore_for_file: do_not_use_environment // Environment constants must be declared here as a single source of truth for dart-define values.

import 'dart:convert';

int _mix(int a, int b) => a ^ b;

List<int> get _k1 => [_mix(0x10, 0x5B), _mix(0x22, 0x1D), _mix(0x70, 0x0A), _mix(0x10, 0x31)];

List<int> get _k2 => [_mix(0x20, 0x7C), _mix(0xF0, 0x7E), _mix(0x55, 0xF4), _mix(0x3A, 0x17)];

List<int> get _xorKey => [..._k1, ..._k2];
List<int> get _xorKey2 => [..._k2.reversed, ..._k1.reversed];

const int _saltLen = 4;

List<int> _xorBytesWithIv(List<int> input, List<int> key, List<int> iv) =>
    List<int>.generate(input.length, (i) => input[i] ^ key[i % key.length] ^ iv[i % iv.length]);

List<int> _demutate(List<int> bytes, List<int> iv) {
  final offset = iv.fold<int>(0, (a, b) => a + b) % 256;
  return List<int>.generate(bytes.length, (i) => (bytes[i] - offset - i) & 0xFF);
}

/// Decodes a value encoded by tool/encode_env.dart.
String _decode(String raw) {
  if (raw.isEmpty) {
    return '';
  }
  // Step 1: outer base64url → strip salt
  final b64Str = utf8.decode(base64Url.decode(raw));
  final stripped = b64Str.substring(_saltLen, b64Str.length - _saltLen);
  // Unshuffle base64
  final b64 = stripped.split('').reversed.join();

  // Step 2: Inner base64 decode
  final packed = base64Url.decode(b64);

  final iv = packed.sublist(0, 8);
  final originalLen = (packed[8] << 8) | packed[9];
  final layer4 = packed.sublist(10);

  // Undo Mutation
  final layer3 = _demutate(layer4, iv);

  // Undo layer 3 XOR
  final layer2 = _xorBytesWithIv(layer3, _xorKey2, iv.reversed.toList());

  // Undo layer 2 Rotation
  final layer1 = layer2.map((b) => ((b >> 3) | (b << 5)) & 0xFF).toList();

  // Undo layer 1 XOR
  final padded = _xorBytesWithIv(layer1, _xorKey, iv);

  return utf8.decode(padded.sublist(0, originalLen));
}

// Raw compile-time values from --dart-define-from-file=.enc.<env>.json
const String _appNameRaw = String.fromEnvironment('k1');
const String _baseUrlRaw = String.fromEnvironment('k2');
const String _telegramBotUrlRaw = String.fromEnvironment('k3');

// Decoded at runtime
String get appName => _decode(_appNameRaw);
String get baseUrl => _decode(_baseUrlRaw);
String get telegramBotUrl => _decode(_telegramBotUrlRaw);

String testDecode(String raw) => _decode(raw);
