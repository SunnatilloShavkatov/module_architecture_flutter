part of 'extension.dart';

extension VersionParsing on String {
  int get toVersion => int.tryParse(replaceAll('.', '')) ?? 0;
}
