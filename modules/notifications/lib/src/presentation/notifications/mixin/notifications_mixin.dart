part of '../notifications_page.dart';

mixin NotificationsMixin on State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  List<NotificationEntity> _notifications = [];
  int _page = 1;
  bool _isLastPage = false;
  String _selectedFilter = NotificationsFilterArgs.defaultFilter;

  void _handleStates(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoadedState) {
      _notifications = state.notifications;
      if (state.notifications.length < Constants.defaultPageLimit) {
        _isLastPage = true;
      } else {
        _page++;
      }
    } else if (state is NotificationsPaginationLoadedState) {
      _notifications = {..._notifications, ...state.notifications}.toList();
      if (state.notifications.length < Constants.defaultPageLimit) {
        _isLastPage = true;
      } else {
        _page++;
      }
    } else if (state is NotificationMarkReadSuccessState) {
      _notifications = _notifications.map((n) {
        if (n.id == state.id) {
          return NotificationEntity(
            id: n.id,
            title: n.title,
            message: n.message,
            timestamp: n.timestamp,
            isRead: true,
            type: n.type,
            timeAgo: n.timeAgo,
          );
        }
        return n;
      }).toList();
      showSuccessMessage(context, message: context.l10n.markedAsRead);
    } else if (state is NotificationClearAllSuccessState) {
      _notifications = [];
      showSuccessMessage(context, message: context.l10n.allNotificationsCleared);
    } else if (state is NotificationActionFailureState) {
      showErrorMessage(context, message: state.message);
    } else if (state is NotificationsFailureState) {
      showErrorMessage(context, message: state.message);
    }
  }

  void _scrollListener() {
    if (_isLastPage || _notifications.isEmpty) {
      return;
    }
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bloc.add(GetPaginatedNotificationsEvent(page: _page));
    }
  }

  List<NotificationEntity> get _filteredNotifications => switch (_selectedFilter) {
    NotificationsFilterArgs.unread => _notifications.where((n) => !n.isRead).toList(),
    NotificationsFilterArgs.read => _notifications.where((n) => n.isRead).toList(),
    _ => _notifications,
  };

  Future<void> _showFilterSheet() async {
    final filter = await context.pushNamed<String>(
      Routes.notificationsFilterSheet,
      extra: NotificationsFilterArgs(selectedFilter: _selectedFilter).toMap(),
    );
    if (filter == null || !mounted) {
      return;
    }
    setState(() => _selectedFilter = filter);
  }

  Future<void> _confirmClearAll() async {
    final confirmed = await context.pushNamed<bool>(Routes.clearNotificationsDialog);
    if (confirmed == true && mounted) {
      bloc.add(const ClearAllNotificationsEvent());
    }
  }

  void _disposeMixin() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
  }

  NotificationsBloc get bloc => context.read<NotificationsBloc>();
}
