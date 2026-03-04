// ignore_for_file: do_not_use_environment // Environment constants must be declared here as a single source of truth for dart-define values.

// Raw compile-time values — never use these directly outside this file.
const String _appNameRaw = String.fromEnvironment('appName');
const String _baseUrlRaw = String.fromEnvironment('baseUrl');
const String _telegramBotUrlRaw = String.fromEnvironment('telegramBotUrl');

// XOR key — change this to any arbitrary byte sequence.
const List<int> _xorKey = [0x4B, 0x3F, 0x7A, 0x21, 0x5C, 0x8E, 0xA1, 0x2D];

/// Encodes a plain string with XOR (returns encoded bytes).
List<int> _xorEncode(String value) =>
    List<int>.generate(value.length, (i) => value.codeUnitAt(i) ^ _xorKey[i % _xorKey.length]);

/// Decodes XOR-encoded bytes back to a plain string at runtime.
String _xorDecode(List<int> encoded) =>
    String.fromCharCodes(List<int>.generate(encoded.length, (i) => encoded[i] ^ _xorKey[i % _xorKey.length]));

// Decoded at runtime (not stored as plain text in binary)
String get appName => _xorDecode(_xorEncode(_appNameRaw));
String get baseUrl => _xorDecode(_xorEncode(_baseUrlRaw));
String get telegramBotUrl => _xorDecode(_xorEncode(_telegramBotUrlRaw));
