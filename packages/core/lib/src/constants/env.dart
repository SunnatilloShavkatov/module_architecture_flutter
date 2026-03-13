import 'package:core/src/constants/_environment_keys.dart' as keys;

enum Environment { dev, prod }

abstract class AppConfig {
  const AppConfig();

  String get appName;

  String get baseUrl;

  String get telegramBotUrl;

  String get boxName;
}

class EnvironmentConfig extends AppConfig {
  const EnvironmentConfig();

  @override
  String get appName => keys.appName;

  @override
  String get baseUrl => keys.baseUrl;

  @override
  String get telegramBotUrl => keys.telegramBotUrl;

  @override
  String get boxName => keys.boxName;
}

final class AppEnvironment {
  const AppEnvironment._({required this.env}) : config = const EnvironmentConfig();

  factory AppEnvironment.initEnvironment({required Environment env}) => _instance = AppEnvironment._(env: env);

  static AppEnvironment? _instance;

  // ignore: prefer_constructors_over_static_methods // Singleton access — cannot be a constructor.
  static AppEnvironment get instance => _instance ?? AppEnvironment.initEnvironment(env: Environment.dev);

  final Environment env;
  final AppConfig config;
}
