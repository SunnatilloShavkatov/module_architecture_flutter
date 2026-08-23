part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const new();
}

final class NotificationsInitialState extends NotificationsState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoadingState extends NotificationsState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationsSuccessState extends NotificationsState {
  const new({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsFailureState extends NotificationsState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
