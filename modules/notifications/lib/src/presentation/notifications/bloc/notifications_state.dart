part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const new();
}

final class NotificationsInitialState extends NotificationsState {
  const new();

  @override
  List<Object?> get props => [];
}

/// Sealed subfamily for notification listing operations.
sealed class NotificationListState extends NotificationsState {
  const new();
}

final class NotificationsLoadingState extends NotificationListState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoadedState extends NotificationListState {
  const new({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsPaginationLoadingState extends NotificationListState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationsPaginationLoadedState extends NotificationListState {
  const new({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsFailureState extends NotificationListState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Sealed subfamily for independent notification actions (mark as read, clear).
sealed class NotificationActionState extends NotificationsState {
  const new();
}

final class NotificationActionLoadingState extends NotificationActionState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationMarkReadSuccessState extends NotificationActionState {
  const new({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

final class NotificationClearAllSuccessState extends NotificationActionState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationActionFailureState extends NotificationActionState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
