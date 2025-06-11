import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/src/utils/utils.dart';

void main() {
  group('phoneFormat', () {
    test('should format valid uzbek phone number', () {
      const input = '+998932221122';
      const expected = '+998 93 222 11 22';
      expect(phoneFormat(input), expected);
    });

    test('should return input if length less than 13', () {
      const input = '12345';
      expect(phoneFormat(input), input);
    });
  });

  group('findChildIndexCallbackKeyInt', () {
    test('returns int value for ObjectKey<int>', () {
      const key = ObjectKey(5);
      expect(findChildIndexCallbackKeyInt(key), 5);
    });

    test('returns null for other key types', () {
      const key = ValueKey('test');
      expect(findChildIndexCallbackKeyInt(key), isNull);
    });
  });
}

