part of "utils.dart";

final String defaultSystemLocale = Platform.localeName.split("_").first;

String get defaultLocale => switch (defaultSystemLocale) {
      "ru" => "ru",
      "en" => "en",
      "uz" => "uz",
      _ => "ru",
    };

String get defaultTheme =>
    SchedulerBinding.instance.platformDispatcher.platformBrightness.name;

String phoneFormat(String phone) {
  if (phone.length >= 13) {
    String t = phone;
    t = t.replaceAll("+998", "");
    t = "${t.substring(0, 2)} ${t.substring(2, 5)} ${t.substring(5, 7)} ${t.substring(7, 9)}";
    return "+998 $t";
  } else {
    return phone;
  }
}
