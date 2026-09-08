import 'package:core/core.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

class MarkNotificationAsRead extends UsecaseWithParams<Unit, MarkNotificationParams> {
  const new(this._repo);

  final NotificationsRepository _repo;

  @override
  ResultFuture<Unit> call(MarkNotificationParams params) => _repo.markAsRead(id: params.id);
}

final class MarkNotificationParams {
  const new({required this.id});

  final String id;
}
