import "package:flutter/services.dart";

class UpperCaseNumberTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Agar matn faqat sonlardan iborat bo'lsa, eski qiymatni qaytarish
    if (RegExp(r"^\d+$").hasMatch(newValue.text)) {
      return oldValue;
    }

    // Agar matn ichida raqamlar bo'lsa, eski qiymatni qaytarish
    if (RegExp("[0-9]").hasMatch(newValue.text)) {
      return oldValue;
    }

    // Agar matn ichida rus harflari bo'lsa, eski qiymatni qaytarish
    if (RegExp("[а-яА-ЯёЁ]").hasMatch(newValue.text)) {
      return oldValue;
    }

    // Har bir so'zning bosh harfini katta qilish
    return TextEditingValue(
      text: capitalizeWords(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalizeWords(String value) {
  if (value.trim().isEmpty) {
    return ""; // Bo'sh satrlar uchun
  }

  return value.split(" ").map((String word) {
    if (word.isEmpty) {
      return word; // Bo'sh so'zlar uchun
    }
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }).join(" ");
}
