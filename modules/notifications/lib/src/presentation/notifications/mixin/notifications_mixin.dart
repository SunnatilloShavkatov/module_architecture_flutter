part of '../notifications_page.dart';

mixin NotificationsMixin on State<NotificationsPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = const ['All', 'Unread', 'Promos'];

  List<NotificationEntity> _filterNotifications(List<NotificationEntity> notifications) =>
      switch (_selectedFilterIndex) {
        1 => notifications.where((notification) => !notification.isRead).toList(),
        2 => notifications.where((notification) => notification.type.toLowerCase() == 'promo').toList(),
        _ => notifications,
      };

  void _onFilterChanged(int index) {
    setState(() => _selectedFilterIndex = index);
  }
}
