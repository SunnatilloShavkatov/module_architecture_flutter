part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

final class NotificationsLoadEvent extends NotificationsEvent {
  const NotificationsLoadEvent();

  @override
  List<Object?> get props => [];
}
