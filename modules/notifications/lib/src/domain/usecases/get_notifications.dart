import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

class GetNotifications extends UsecaseWithParams<List<NotificationEntity>, GetNotificationsParams> {
  const new(this._repo);

  final NotificationsRepository _repo;

  @override
  ResultFuture<List<NotificationEntity>> call(GetNotificationsParams params) =>
      _repo.getNotifications(page: params.page, limit: params.limit);
}

final class GetNotificationsParams extends Equatable {
  const new({required this.page, this.limit = Constants.defaultPageLimit});

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}
