import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_api_paths.dart';
import 'package:notifications/src/data/models/notification_model.dart';

part 'notifications_remote_data_source_impl.dart';

abstract interface class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource();

  Future<List<NotificationModel>> getNotifications();
}
