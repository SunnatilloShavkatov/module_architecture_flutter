import 'package:core/core.dart';
import 'package:profile/src/data/datasource/profile_local_data_source_impl.dart';
import 'package:profile/src/data/datasource/profile_remote_data_source.dart';
import 'package:profile/src/domain/repository/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteSource, this._localSource);

  final ProfileLocalDataSource _localSource;
  final ProfileRemoteDataSource _remoteSource;

  @override
  ResultFuture<void> getMoreData() async {
    try {
      final result = await _remoteSource.getMoreData();
      return Right<Failure, void>(result);
    } on ServerException catch (error, _) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
