// Run: dart tool/encode_env.dart
// Encodes .env.dev.json  → .enc.dev.json
//         .env.prod.json → .enc.prod.json
//
// Each string value is XOR+base64url encoded (keys stay plain so dart-define can read them).
// Use in build: --dart-define-from-file=.enc.dev.json

// ignore_for_file: avoid_print // CLI tool — stdout output is intentional

import 'dart:convert';
import 'dart:io';
import 'dart:math';

int _mix(int a, int b) => a ^ b;

List<int> get _k1 => [_mix(0x10, 0x5B), _mix(0x22, 0x1D), _mix(0x70, 0x0A), _mix(0x10, 0x31)];

List<int> get _k2 => [_mix(0x20, 0x7C), _mix(0xF0, 0x7E), _mix(0x55, 0xF4), _mix(0x3A, 0x17)];

List<int> get _xorKey => [..._k1, ..._k2];

List<int> get _xorKey2 => [..._k2.reversed, ..._k1.reversed];

// Salt: mixed into inner string before outer base64 pass
String get _salt => String.fromCharCodes([_mix(0x61, 0x12), _mix(0x4F, 0x1C), _mix(0x32, 0x41), _mix(0x58, 0x21)]);

List<int> _xorBytesWithIv(List<int> input, List<int> key, List<int> iv) =>
    List<int>.generate(input.length, (i) => input[i] ^ key[i % key.length] ^ iv[i % iv.length]);

List<int> _mutate(List<int> bytes, List<int> iv) {
  final offset = iv.fold<int>(0, (a, b) => a + b) % 256;
  return List<int>.generate(bytes.length, (i) => (bytes[i] + offset + i) & 0xFF);
}

String _encodeValue(String value) {
  final raw = utf8.encode(value);
  final iv = List<int>.generate(8, (_) => Random.secure().nextInt(256));

  final padLen = (16 - raw.length % 16) % 16;
  final padded = [...raw, ...List<int>.generate(padLen, (i) => Random.secure().nextInt(256))];

  final layer1 = _xorBytesWithIv(padded, _xorKey, iv);
  final layer2 = layer1.map((b) => ((b << 3) | (b >> 5)) & 0xFF).toList();
  final layer3 = _xorBytesWithIv(layer2, _xorKey2, iv.reversed.toList());
  final layer4 = _mutate(layer3, iv);

  final lenBytes = [(raw.length >> 8) & 0xFF, raw.length & 0xFF];
  final packed = [...iv, ...lenBytes, ...layer4];

  final b64 = base64UrlEncode(packed);
  final shuffledBase64 = _salt + b64.split('').reversed.join() + _salt;
  return base64UrlEncode(utf8.encode(shuffledBase64));
}

Map<String, dynamic> _encodeMap(Map<String, dynamic> input) {
  const keyMap = {'appName': 'k1', 'baseUrl': 'k2', 'telegramBotUrl': 'k3', 'boxName': 'k4'};
  return {
    for (final entry in input.entries)
      keyMap[entry.key] ?? entry.key: entry.value is String ? _encodeValue(entry.value as String) : entry.value,
  };
}

void _processFile(String inputPath, String outputPath) {
  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    print('SKIP: $inputPath topilmadi');
    return;
  }

  final raw = inputFile.readAsStringSync();
  final inputJson = jsonDecode(raw) as Map<String, dynamic>;
  final encoded = _encodeMap(inputJson);

  File(outputPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(encoded));
  print('OK: $inputPath → $outputPath');
}

void main() {
  const configs = [('.env.dev.json', '.enc.dev.json'), ('.env.prod.json', '.enc.prod.json')];

  for (final (input, output) in configs) {
    _processFile(input, output);
  }
}
