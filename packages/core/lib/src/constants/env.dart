enum Environment { dev, prod }

abstract class AppConfig {
  const AppConfig();

  String get baseUrl;

  String get apiToken;

  String get appName;
}

class DevEnvironment extends AppConfig {
  const DevEnvironment();

  @override
  String get baseUrl => devBaseUrl;

  @override
  String get apiToken => devApiToken;

  @override
  String get appName => 'App Name Dev';
}

class ProdEnvironment extends AppConfig {
  const ProdEnvironment();

  @override
  String get baseUrl => prodBaseUrl;

  @override
  String get apiToken => prodApiToken;

  @override
  String get appName => 'App Name';
}

class AppEnvironment {
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

/// prod
const String prodBaseUrl = 'https://handbook.uz';
const String prodApiToken = '';

/// dev
const String devBaseUrl = 'https://handbook.uz';
const String devApiToken = '';

///
///
