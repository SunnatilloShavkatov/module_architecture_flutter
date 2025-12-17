part of 'extension.dart';

extension MoneyFormatExtension on num {
  String get moneyFormat {
    final format = NumberFormat('#,##0.###', 'en_US');
    final result = format.format(abs()).replaceAll(format.symbols.GROUP_SEP, ' ');
    return isNegative ? '-$result' : result;
  }
}

extension StringMoneyFormatExtension on String {
  String get moneyFormat {
    final num? value = num.tryParse(this);
    if (value == null) {
      return this;
    }
    return value.moneyFormat;
  }
}
