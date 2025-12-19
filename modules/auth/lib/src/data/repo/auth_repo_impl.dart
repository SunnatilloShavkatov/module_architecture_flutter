import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:auth/src/domain/repo/auth_repo.dart';
import 'package:core/core.dart';

final class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteSource, this._dataSource);

  final AuthLocalDataSource _dataSource;
  final AuthRemoteDataSource _remoteSource;

  @override
  ResultFuture<LoginEntity> isLoggedIn() async {
    try {
      final result = await _remoteSource.login(
        fcmToken: '',
        identity: 'identity',
        password: 'password',
        deviceType: 100,
        deviceInfo: {},
        packageInfo: {},
      );
      if ((result.token ?? '').isNotEmpty) {
        await _dataSource.saveUser(result);
      }
      return Right(result);
    } on ServerException catch (error, _) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
