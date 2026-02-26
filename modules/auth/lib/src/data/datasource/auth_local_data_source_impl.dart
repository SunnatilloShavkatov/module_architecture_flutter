part of 'auth_local_data_source.dart';

final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;

  @override
  Future<void> saveUser(UserModel user) async {
    await Future.wait([
      if (user.token != null) _localSource.setAccessToken(user.token!),
      _localSource.setFirstName(user.firstName),
      if (user.phone != null) _localSource.setPhone(user.phone!),
      _localSource.setUserId(user.id),
    ]);
  }
}
