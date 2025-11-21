import 'package:core/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
