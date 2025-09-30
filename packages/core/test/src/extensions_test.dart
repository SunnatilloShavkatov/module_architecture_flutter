import 'package:core/src/extension/extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VersionParsing', () {
    test('toVersion removes dots and parses', () {
      expect('1.2.30'.toVersion, 1230);
      expect(''.toVersion, 0);
    });
  });

  group('MoneyFormatExtension', () {
    test('moneyFormat basic grouping', () {
      expect(12345.moneyFormat, '12 345');
      expect((-12345).moneyFormat, '-12 345');
    });

    test('moneyFormatSymbol appends ', () {
      expect(1000.moneyFormatSymbol, r'1 000 $');
    });
  });
}
