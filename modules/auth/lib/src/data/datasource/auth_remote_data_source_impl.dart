part of 'auth_remote_data_source.dart';

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<LoginModel> login({
    required int deviceType,
    required String identity,
    required String password,
    required String? fcmToken,
    required Map<String, dynamic> deviceInfo,
    required Map<String, dynamic> packageInfo,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'identity': identity,
        'password': password,
        'device_type': deviceType,
        'device_info': deviceInfo,
        'package_info': packageInfo,
        if (fcmToken != null) 'fcm_token': fcmToken,
      };
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        ApiPaths.login,
        data: data,
        methodType: RMethodTypes.post,
      );
      return LoginModel.fromMap(result.data ?? {});
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
