import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';

abstract interface class NotificationsRepository {
  const NotificationsRepository();

  ResultFuture<List<NotificationEntity>> getNotifications();
}
