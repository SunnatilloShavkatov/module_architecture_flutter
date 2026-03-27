import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

class GetNotifications extends UsecaseWithoutParams<List<NotificationEntity>> {
  const GetNotifications(this._repo);

  final NotificationsRepository _repo;

  @override
  ResultFuture<List<NotificationEntity>> call() => _repo.getNotifications();
}
