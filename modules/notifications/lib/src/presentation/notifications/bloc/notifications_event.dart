part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const new();
}

final class NotificationsLoadEvent extends NotificationsEvent {
  const new();

  @override
  List<Object?> get props => [];
}
