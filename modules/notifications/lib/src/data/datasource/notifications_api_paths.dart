final class NotificationsApiPaths {
  const new _();

  static const String clientNotifications = '/api/notifications/client';
  static const String markAsRead = '/api/notifications/client/{id}/read';
  static const String clearAll = '/api/notifications/client/clear';
  static const String unreadCount = '/api/notifications/client/unread-count';
}
