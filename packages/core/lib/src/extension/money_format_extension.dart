part of 'extension.dart';

extension MoneyFormatExtension on num {
  String get moneyFormat {
    final formatter = NumberFormat('#,##0.######', 'en_US');
    final formatted = formatter.format(abs()).replaceAll(',', ' ');
    return isNegative ? '-$formatted' : formatted;
  }

  String get moneyFormatSymbol => '$moneyFormat \$';
}

extension StringMoneyFormatExtension on String {
  String get moneyFormat {
    final num? value = num.tryParse(this);
    if (value == null) {
      return this;
    }
    return value.moneyFormat;
  }

  String get moneyFormatSymbol {
    final num? value = num.tryParse(this);
    if (value == null) {
      return this;
    }
    return value.moneyFormatSymbol;
  }
}
