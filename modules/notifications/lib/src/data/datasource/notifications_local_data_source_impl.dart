part of 'notifications_local_data_source.dart';

final class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  const NotificationsLocalDataSourceImpl();

  @override
  List<NotificationModel> getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        title: 'Appointment confirmed',
        message: 'Your appointment has been confirmed.',
        timestamp: now.subtract(const Duration(minutes: 10)),
        timeAgo: '10 min ago',
        type: 'confirmation',
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'New discount available',
        message: 'Special offers are now active in your area.',
        timestamp: now.subtract(const Duration(hours: 2)),
        timeAgo: '2 hours ago',
        type: 'promo',
        isRead: true,
      ),
      NotificationModel(
        id: '3',
        title: 'Reminder',
        message: 'Your appointment is scheduled for tomorrow.',
        timestamp: now.subtract(const Duration(days: 1)),
        timeAgo: '1 day ago',
        type: 'reminder',
        isRead: false,
      ),
    ];
  }
}
