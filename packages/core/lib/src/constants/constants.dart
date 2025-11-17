import 'dart:io';

import 'package:core/src/constants/env.dart';

final class Constants {
  const Constants._();

  static AppConfig get config => AppEnvironment.instance.config;

  static String get baseUrl => AppEnvironment.instance.config.baseUrl;

  static Environment get environment => AppEnvironment.instance.currentEnv;

  static const String defaultSmsCodeMatcher = r'([0-9]{6})\s*(?=\r?\n[A-Za-z0-9]{6,})';

  static final String appLink = Platform.isIOS
      ? 'https://apps.apple.com/us/app/q-watt-powerbank-sharing/id6444178516'
      : 'https://play.google.com/store/apps/details?id=com.q.watt';
}
