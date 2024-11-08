part of "extension.dart";

extension ParseString on DateTime {
  String get formatDate => DateFormat("dd.MM.yyyy").format(this);

  String get formatDateTime =>
      DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(this);

  String timeZone() {
    String date = toIso8601String().split(".")[0];
    if (timeZoneOffset.isNegative) {
      date += "-";
    } else {
      date += "+";
    }
    final List<String> timeZoneSplit = timeZoneOffset.toString().split(":");

    final int hour = int.parse(timeZoneSplit[0]);
    if (hour < 10) {
      date += "0${timeZoneSplit[0]}";
    }
    return date += ":${timeZoneSplit[1]}";
  }
}

extension ParseExtension on String {
  String Function() get date => () {
        if (isEmpty) {
          return "";
        }
        final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
        final DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(this);
        return DateFormat("dd.MM.yyyy").format(
          date.add(Duration(hours: duration)),
        );
      };

  String Function() get dateTime => () {
        if (isEmpty) {
          return "";
        }
        final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
        final DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(this);
        return DateFormat("dd.MM.yyyy HH:mm").format(
          date.add(Duration(hours: duration)),
        );
      };

  String dateTime1() {
    if (isEmpty) {
      return "";
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(this);
    return DateFormat("dd.MM.yyyy").format(
      date.add(Duration(hours: duration)),
    );
  }

  String dateTime2() {
    if (isEmpty) {
      return "";
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat("MM.dd.yyyy").parse(this);
    return DateFormat("yyyy-MM-dd").format(
      date.add(Duration(hours: duration)),
    );
  }

  String time1() {
    if (isEmpty) {
      return "";
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat("HH:mm").parse(this);
    return DateFormat("HH:mm").format(
      date.add(Duration(hours: duration)),
    );
  }

  String time() {
    if (isEmpty) {
      return "";
    }
    final int duration = DateTime.now().hour - DateTime.now().toUtc().hour;
    final DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(this);
    return DateFormat("HH:mm").format(
      date.add(Duration(hours: duration)),
    );
  }

  String get htmlToText => Bidi.stripHtmlIfNeeded(this);
}
