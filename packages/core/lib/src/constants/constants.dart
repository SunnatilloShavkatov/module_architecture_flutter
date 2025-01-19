import 'dart:io';

import 'package:core/src/constants/env.dart';

sealed class Constants {
  const Constants._();

  static String get baseUrl => AppEnvironment.instance.config.baseUrl;

  static AppConfig get config => AppEnvironment.instance.config;

  static Environment get environment => AppEnvironment.instance.currentEnv;

  /// id
  static const String clientTypeId = '';
  static const String companyId = '';
  static const String roleId = '';

  static final String appLink = Platform.isIOS
      ? 'https://apps.apple.com/us/app/q-watt-powerbank-sharing/id6444178516'
      : 'https://play.google.com/store/apps/details?id=com.q.watt';
}

class Validations {
  const Validations._();

  static const String emailEmpty = 'Email cannot be empty';
  static const String notEmail = 'This is not email';
  static const String passwordEmpty = 'Password cannot be empty';
  static const String passwordShort = 'Password too short';
  static const String passwordLong = 'Password too long';
  static const String firstnameEmpty = 'Firstname cannot be empty';
  static const String firstnameShort = 'Firstname too short';
  static const String firstnameLong = 'Firstname too long';
  static const String lastnameEmpty = 'Last name cannot be empty';
  static const String lastnameShort = 'Lastname too short';
  static const String lastnameLong = 'Lastname too long';
  static const String passwordNotMatch = 'Passwords do not match';
  static const String internetFailure = 'No Internet';
  static const String somethingWentWrong = 'Something went wrong!';
}

sealed class AppKeys {
  const AppKeys._();

  static const String locale = 'locale';
  static const String hasProfile = 'has_profile';
  static const String accessToken = 'access_token';
  static const String firstname = 'firstname';
  static const String lastname = 'lastname';
  static const String email = 'email';
  static const String password = 'password';
  static const String themeMode = 'theme_mode';
  static const String imageCache = 'image_cache';
}

sealed class Urls {
  const Urls._();

  static const String sendCode = '/v2/send-code';
  static const String loginWithOption = '/v2/login/with-option';
  static const String register = '/v2/register';

  static const String objectSlim = '/v1/object-slim';
}
