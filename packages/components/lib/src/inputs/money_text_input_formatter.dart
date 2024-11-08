import "package:flutter/services.dart";

class MoneyTextInputFormatter extends TextInputFormatter {
  MoneyTextInputFormatter({
    this.isUsd = false,
  });

  final bool isUsd;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: "");
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      final String reversedText =
          String.fromCharCodes(newValue.text.runes.toList().reversed);
      final List<String> chars = reversedText.replaceAll(" ", "").split("");
      final StringBuffer reversedNewStringBuffer = StringBuffer();
      for (int i = 0; i < chars.length; i++) {
        if (i % 3 == 0 && i != 0) {
          reversedNewStringBuffer.write(" ");
        }
        reversedNewStringBuffer.write(chars[i]);
      }
      String newString = String.fromCharCodes(
        reversedNewStringBuffer.toString().runes.toList().reversed,
      );
      newString = isUsd ? "\$$newString" : newString;
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
