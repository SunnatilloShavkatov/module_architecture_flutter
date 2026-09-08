import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_local_data_source.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

final class NotificationsRepositoryImpl implements NotificationsRepository {
  const new(this._remoteDataSource, this._localDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;

  @override
  ResultFuture<List<NotificationEntity>> getNotifications({
    required int page,
    int limit = Constants.defaultPageLimit,
  }) async {
    try {
      final result = await _remoteDataSource.getNotifications(page: page, limit: limit);
      if (result.isEmpty && page == 1) {
        return Right(_localDataSource.getMockNotifications());
      }
      return Right(result);
    } on ServerException catch (error) {
      final local = _localDataSource.getMockNotifications();
      if (local.isNotEmpty && page == 1) {
        return Right(local);
      }
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  ResultFuture<Unit> markAsRead({required String id}) async {
    try {
      await _remoteDataSource.markAsRead(id: id);
      return const Right(unit);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  ResultFuture<Unit> clearAll() async {
    try {
      await _remoteDataSource.clearAll();
      return const Right(unit);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  ResultFuture<int> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
