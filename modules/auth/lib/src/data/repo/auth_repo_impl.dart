import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

final class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  ResultFuture<UserEntity> login({required String email, required String password}) async {
    try {
      final result = await _remoteDataSource.login(email: email, password: password);
      await _localDataSource.saveUser(result);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.failure);
    } catch (e, s) {
      logMessage('Login Error: $e', error: e, stackTrace: s);
      return Left(ServerFailure(message: LocalizedMessages.instance.tr(LocalizationKeys.somethingWrong)));
    }
  }

  @override
  ResultFuture<UserEntity> otpLogin({required String code}) async {
    try {
      final result = await _remoteDataSource.otpLogin(code: code);
      await _localDataSource.saveUser(result);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.failure);
    } catch (e, s) {
      logMessage('OTP Login Error: $e', error: e, stackTrace: s);
      return Left(ServerFailure(message: LocalizedMessages.instance.tr(LocalizationKeys.somethingWrong)));
    }
  }
}
