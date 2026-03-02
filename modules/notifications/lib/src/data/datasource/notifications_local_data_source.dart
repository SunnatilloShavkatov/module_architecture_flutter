import 'package:notifications/src/data/models/notification_model.dart';

part 'notifications_local_data_source_impl.dart';

abstract interface class NotificationsLocalDataSource {
  const NotificationsLocalDataSource();

  List<NotificationModel> getMockNotifications();
}
