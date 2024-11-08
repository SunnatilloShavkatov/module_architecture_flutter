part of "extension.dart";

extension MoneyFormatExtension on num {
  String get moneyFormat => isNegative
      ? "-${NumberFormat().format(abs()).split(",").join(" ")}"
      : NumberFormat().format(this).split(",").join(" ");

  String get moneyFormatSymbol => "$moneyFormat \$";

  String formatter() {
    final num currentBalance = this;
    final bool t = currentBalance.isNegative;
    final num value = currentBalance.abs();
    if (value < 10) {
      return (t ? "-" : "") + value.toInt().toString();
    } else if (value < 1000) {
      final String text = value.round().toString();
      return (t ? "-" : "") + text;
    } else if (value >= 1000 && value < 1000000) {
      return (t ? "-" : "") +
          NumberFormat.compactCurrency(decimalDigits: 3, symbol: "")
              .format(value.round());
    } else if (value >= 1000000 && value < (1000000 * 1000)) {
      return (t ? "-" : "") +
          NumberFormat.compactCurrency(decimalDigits: 6, symbol: "")
              .format(value.round());
    } else if (value >= (1000000 * 1000) && value < (1000000 * 1000 * 100)) {
      return (t ? "-" : "") +
          NumberFormat.compactCurrency(decimalDigits: 9, symbol: "")
              .format(value.round());
    } else if (value >= (1000000 * 1000 * 1000) &&
        value < (1000000 * 1000 * 1000 * 1000)) {
      return (t ? "-" : "") +
          NumberFormat.compactCurrency(decimalDigits: 12, symbol: "")
              .format(value.round());
    } else {
      return "";
    }
  }
}
