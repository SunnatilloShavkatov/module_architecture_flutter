import 'package:core/core.dart';
import 'package:profile/src/data/datasource/profile_local_data_source_impl.dart';
import 'package:profile/src/data/datasource/profile_remote_data_source.dart';
import 'package:profile/src/data/models/profile_user_model.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/domain/repository/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteSource, this._localSource);

  final ProfileLocalDataSource _localSource;
  final ProfileRemoteDataSource _remoteSource;

  @override
  ResultFuture<ProfileUserEntity> getProfileUser() async {
    ProfileUserModel? cached;
    try {
      cached = _localSource.getProfileUser();
    } catch (_) {
      // local cache read failed, proceed without cache
    }
    try {
      final result = await _remoteSource.getProfileUser();
      await _localSource.saveProfileUser(result);
      return Right(result);
    } on ServerException catch (error) {
      if (cached != null) {
        return Right(cached);
      }
      return Left(error.failure);
    } on Exception catch (error) {
      if (cached != null) {
        return Right(cached);
      }
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  ResultFuture<ProfileUserEntity> updateProfile({
    required String username,
    required String firstName,
    required String lastName,
    required String phone,
    required String specialization,
  }) async {
    try {
      final result = await _remoteSource.updateProfile(
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        specialization: specialization,
      );
      await _localSource.saveProfileUser(result);
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
