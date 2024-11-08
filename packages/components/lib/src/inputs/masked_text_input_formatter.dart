import "package:flutter/services.dart";

class MaskedTextInputFormatter extends TextInputFormatter {
  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
    required this.filter,
  });

  final String mask;
  final String separator;
  final RegExp filter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;
    final String cleanText = text.replaceAll(separator, "");
    final Iterable<Match> matches = filter.allMatches(cleanText);

    // Agar matn filtrga mos kelmasa, eski qiymatni qaytarish
    if (matches.length != cleanText.length) {
      return oldValue;
    }

    // Matn bo'sh bo'lmasa davom etadi
    if (text.isNotEmpty) {
      if (text.length > oldValue.text.length) {
        // Matn maskadan uzun bo'lmasligi kerak
        if (text.length > mask.length) {
          return oldValue;
        }

        // Agar qo'shish kerak bo'lsa va yangi belgidan oldin separator kiritish kerak bo'lsa
        if (text.length < mask.length && mask[text.length - 1] == separator) {
          return TextEditingValue(
            text:
                "${oldValue.text}$separator${text.substring(text.length - 1)}",
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }

        // Matn butunlay to'ldirilganda separatorlar bilan formatlash
        if (text.length == mask.replaceAll(separator, "").length &&
            oldValue.text.isEmpty) {
          final StringBuffer formattedText = StringBuffer();
          int t = 0;
          for (int i = 0; i < text.length; i++) {
            if (mask[i + t] == separator) {
              formattedText.write(separator);
              t++;
            }
            formattedText.write(text[i]);
          }
          return TextEditingValue(
            text: formattedText.toString(),
            selection: TextSelection.collapsed(
              offset: formattedText.toString().length,
            ),
          );
        }
      } else {
        // Agar oxirgi belgi separator bo'lsa, uni olib tashlash
        if (text.endsWith(separator)) {
          return TextEditingValue(
            text: text.substring(0, text.length - 1),
            selection: TextSelection.collapsed(
              offset: newValue.selection.end - 1,
            ),
          );
        }
      }

      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: newValue.selection.end),
      );
    }

    return newValue;
  }
}
