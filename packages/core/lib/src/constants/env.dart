import 'package:core/src/constants/.key.dart';

enum Environment { dev, prod }

abstract class AppConfig {
  const AppConfig();

  String get appName;

  String get baseUrl;

  String get telegramBotUrl;
}

class DevEnvironment extends AppConfig {
  const DevEnvironment();

  @override
  String get appName => 'App Name Dev';

  @override
  String get baseUrl => devBaseUrl;

  @override
  String get telegramBotUrl => devTelegramBotUrl;
}

class ProdEnvironment extends AppConfig {
  const ProdEnvironment();

  @override
  String get appName => 'App Name';

  @override
  String get baseUrl => prodBaseUrl;

  @override
  String get telegramBotUrl => prodTelegramBotUrl;
}

final class AppEnvironment {
  AppEnvironment._internal();

  static AppEnvironment get instance => _singleton;

  static final AppEnvironment _singleton = AppEnvironment._internal();

  late AppConfig config;
  late Environment _currentEnv;

  void initEnvironment({required Environment env}) {
    config = _getConfig(env);
  }

  AppConfig _getConfig(Environment env) {
    _currentEnv = env;
    switch (env) {
      case Environment.prod:
        return const ProdEnvironment();
      case Environment.dev:
        return const DevEnvironment();
    }
  }

  Environment get currentEnv => _currentEnv;
}
