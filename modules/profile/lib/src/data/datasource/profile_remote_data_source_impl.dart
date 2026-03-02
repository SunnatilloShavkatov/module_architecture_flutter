part of 'profile_remote_data_source.dart';

final class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<ProfileUserModel> getProfileUser() async {
    try {
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        ProfileApiPaths.getMe,
        methodType: RMethodTypes.get,
      );
      return ProfileUserModel.fromMap(result.data ?? {});
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

  @override
  Future<ProfileUserModel> updateProfile({
    required String username,
    required String firstName,
    required String lastName,
    required String phone,
    required String specialization,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'specialization': specialization,
      };
      await _networkProvider.fetchMethod<dynamic>(
        ProfileApiPaths.profile,
        methodType: RMethodTypes.put,
        data: data,
      );
      return await getProfileUser();
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
