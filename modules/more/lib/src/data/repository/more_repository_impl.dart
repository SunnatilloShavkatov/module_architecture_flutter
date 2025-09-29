// ignore_for_file: unused_field

part of 'package:more/src/domain/repository/more_repository.dart';

final class MoreRepositoryImpl implements MoreRepository {
  const MoreRepositoryImpl(this._remoteSource, this._localSource);

  final MoreLocalDataSource _localSource;
  final MoreRemoteDataSource _remoteSource;

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
