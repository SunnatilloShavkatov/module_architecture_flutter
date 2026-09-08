import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_api_paths.dart';
import 'package:notifications/src/data/models/notification_model.dart';

part 'notifications_remote_data_source_impl.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({required int page, int limit = Constants.defaultPageLimit});

  Future<void> markAsRead({required String id});

  Future<void> clearAll();

  Future<int> getUnreadCount();
}
