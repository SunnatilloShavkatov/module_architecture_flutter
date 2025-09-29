part of 'auth_local_data_source.dart';

final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;

  @override
  Future<void> saveUser(LoginModel login) async {
    await Future.wait([
      _localSource.setLastName(login.profile?.lastname ?? ''),
      _localSource.setFirstName(login.profile?.firstname ?? ''),
      if (login.token != null) _localSource.setAccessToken(login.token!),
    ]);
  }
}
