part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const new();
}

final class GetNotificationsEvent extends NotificationsEvent {
  const new();

  @override
  List<Object?> get props => [];
}

final class GetPaginatedNotificationsEvent extends NotificationsEvent {
  const new({required this.page});

  final int page;

  @override
  List<Object?> get props => [page];
}

final class MarkNotificationAsReadEvent extends NotificationsEvent {
  const new({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

final class ClearAllNotificationsEvent extends NotificationsEvent {
  const new();

  @override
  List<Object?> get props => [];
}
