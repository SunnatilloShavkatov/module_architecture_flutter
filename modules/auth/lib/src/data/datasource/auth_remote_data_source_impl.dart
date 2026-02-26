part of 'auth_remote_data_source.dart';

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'password': password};
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        ApiPaths.login,
        data: data,
        methodType: RMethodTypes.post,
      );
      final user = UserModel.fromMap(result.data ?? {});
      if (user.token != null) {
        _networkProvider.setAccessToken(user.token!);
      }
      return user;
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      } else {
        throw ServerException.unknownError(locale: _networkProvider.locale);
      }
    }
  }
}
