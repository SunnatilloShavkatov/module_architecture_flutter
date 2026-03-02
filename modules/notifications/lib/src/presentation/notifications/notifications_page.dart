import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Unread', 'Promos'];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notifications')),
    body: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) => switch (state) {
          NotificationsInitialState() || NotificationsLoadingState() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          NotificationsFailureState() => Center(
            child: Text(
              state.message,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
          NotificationsSuccessState() => _NotificationsContent(
            notifications: _filterNotifications(state.notifications),
            filters: _filters,
            selectedFilterIndex: _selectedFilterIndex,
            onFilterChanged: (index) => setState(() => _selectedFilterIndex = index),
          ),
        },
      ),
    ),
  );

  List<NotificationEntity> _filterNotifications(List<NotificationEntity> notifications) => switch (_selectedFilterIndex) {
    1 => notifications.where((notification) => !notification.isRead).toList(),
    2 => notifications.where((notification) => notification.type.toLowerCase() == 'promo').toList(),
    _ => notifications,
  };
}

final class _NotificationsContent extends StatelessWidget {
  const _NotificationsContent({
    required this.notifications,
    required this.filters,
    required this.selectedFilterIndex,
    required this.onFilterChanged,
  });

  final List<NotificationEntity> notifications;
  final List<String> filters;
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            final isSelected = selectedFilterIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: isSelected,
                label: Text(filters[index]),
                onSelected: (_) => onFilterChanged(index),
              ),
            );
          }),
        ),
      ),
      Dimensions.kGap16,
      Expanded(
        child: notifications.isEmpty
            ? const Center(child: Text('No notifications'))
            : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, _) => Dimensions.kGap12,
                itemBuilder: (_, index) {
                  final notification = notifications[index];
                  return Container(
                    padding: Dimensions.kPaddingAll12,
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.kBorderRadius12,
                      color: notification.isRead
                          ? context.color.background
                          : context.color.primary.withValues(alpha: 0.08),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Dimensions.kGap4,
                        Text(notification.message, style: context.textTheme.bodyMedium),
                        Dimensions.kGap4,
                        Text(notification.timeAgo ?? '', style: context.textTheme.bodySmall),
                      ],
                    ),
                  );
                },
              ),
      ),
    ],
  );
}
