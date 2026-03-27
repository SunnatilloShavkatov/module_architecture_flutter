import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ru'), Locale('uz')];

  /// No description provided for @home.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get home;

  /// No description provided for @units.
  ///
  /// In ru, this message translates to:
  /// **'Единицы'**
  String get units;

  /// No description provided for @resources.
  ///
  /// In ru, this message translates to:
  /// **'Ресурсы'**
  String get resources;

  /// No description provided for @more.
  ///
  /// In ru, this message translates to:
  /// **'Еще'**
  String get more;

  /// No description provided for @profile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @handbookTitle.
  ///
  /// In ru, this message translates to:
  /// **'Handbook'**
  String get handbookTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'добро пожаловать в систему'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Ваш премиум помощник'**
  String get welcomeDescription;

  /// No description provided for @proceedButton.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get proceedButton;

  /// No description provided for @getHelp.
  ///
  /// In ru, this message translates to:
  /// **'Получить помощь'**
  String get getHelp;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Войдите в свой аккаунт чтобы продолжить'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In ru, this message translates to:
  /// **'Запомнить меня'**
  String get rememberMe;

  /// No description provided for @loginButton.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginButton;

  /// No description provided for @telegramLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Telegram'**
  String get telegramLogin;

  /// No description provided for @emailRequired.
  ///
  /// In ru, this message translates to:
  /// **'Email обязателен'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In ru, this message translates to:
  /// **'Пароль обязателен'**
  String get passwordRequired;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In ru, this message translates to:
  /// **'Успешный вход в систему'**
  String get loginSuccessMessage;

  /// No description provided for @noNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Нет уведомлений'**
  String get noNotifications;

  /// No description provided for @addCard.
  ///
  /// In ru, this message translates to:
  /// **'Добавить карту'**
  String get addCard;

  /// No description provided for @saveCard.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить карту'**
  String get saveCard;

  /// No description provided for @cardNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер карты'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In ru, this message translates to:
  /// **'Срок действия (ММ/ГГ)'**
  String get expiryDate;

  /// No description provided for @invalidCardNumber.
  ///
  /// In ru, this message translates to:
  /// **'Неверный номер карты'**
  String get invalidCardNumber;

  /// No description provided for @noPaymentMethods.
  ///
  /// In ru, this message translates to:
  /// **'Нет способов оплаты'**
  String get noPaymentMethods;

  /// No description provided for @categories.
  ///
  /// In ru, this message translates to:
  /// **'Категории'**
  String get categories;

  /// No description provided for @barbershops.
  ///
  /// In ru, this message translates to:
  /// **'Парикмахерские'**
  String get barbershops;

  /// No description provided for @haveGoodDay.
  ///
  /// In ru, this message translates to:
  /// **'Хорошего дня'**
  String get haveGoodDay;

  /// No description provided for @welcomeGreeting.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать'**
  String get welcomeGreeting;

  /// No description provided for @editProfile.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get editProfile;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Профиль успешно обновлён'**
  String get profileUpdatedSuccess;

  /// No description provided for @usernameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя пользователя'**
  String get usernameLabel;

  /// No description provided for @mobileNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер телефона'**
  String get mobileNumber;

  /// No description provided for @fieldRequired.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get fieldRequired;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
