part of 'extension.dart';

extension LocalizationstExtension on BuildContext {
  Locale get locale => Localizations.localeOf(this);

  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
