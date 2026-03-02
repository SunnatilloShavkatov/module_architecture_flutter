part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();
}

final class NotificationsInitialState extends NotificationsState {
  const NotificationsInitialState();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoadingState extends NotificationsState {
  const NotificationsLoadingState();

  @override
  List<Object?> get props => [];
}

final class NotificationsSuccessState extends NotificationsState {
  const NotificationsSuccessState({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsFailureState extends NotificationsState {
  const NotificationsFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
