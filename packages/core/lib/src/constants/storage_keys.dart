final class StorageKeys {
  const StorageKeys._();

  /// system
  static const String locale = 'locale';
  static const String themeMode = 'theme_mode';

  /// logout clear
  static const String accessToken = 'access_token';
  static const String firstname = 'firstname';
  static const String lastname = 'lastname';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String role = 'role';
  static const String userData = 'user_data';
  static const String userId = 'user_id';

  static const Set<String> keep = <String>{locale, themeMode};
}
