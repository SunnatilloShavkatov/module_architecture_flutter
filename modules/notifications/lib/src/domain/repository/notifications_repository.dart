import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';

abstract interface class NotificationsRepository {
  ResultFuture<List<NotificationEntity>> getNotifications({required int page, int limit = Constants.defaultPageLimit});

  ResultFuture<Unit> markAsRead({required String id});

  ResultFuture<Unit> clearAll();

  ResultFuture<int> getUnreadCount();
}
