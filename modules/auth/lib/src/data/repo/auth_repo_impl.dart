import 'package:auth/src/data/datasource/auth_remote_datasource.dart';
import 'package:auth/src/domain/entities/auth_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

final class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<AuthEntity> login({required String username, required String password}) async {
    try {
      final result = await _remoteDataSource.login(username: username, password: password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? '', statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
