import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

final class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<LoginEntity> login({
    required int deviceType,
    required String identity,
    required String password,
    required String? fcmToken,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        deviceType: deviceType,
        identity: identity,
        password: password,
        fcmToken: fcmToken,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? '', statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
