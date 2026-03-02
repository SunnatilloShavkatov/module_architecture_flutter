import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_local_data_source.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

final class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;

  @override
  ResultFuture<List<NotificationEntity>> getNotifications() async {
    try {
      final result = await _remoteDataSource.getNotifications();
      if (result.isEmpty) {
        return Right(_localDataSource.getMockNotifications());
      }
      return Right(result);
    } on ServerException catch (_) {
      return Right(_localDataSource.getMockNotifications());
    } on Exception catch (e) {
      final local = _localDataSource.getMockNotifications();
      if (local.isNotEmpty) {
        return Right(local);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
