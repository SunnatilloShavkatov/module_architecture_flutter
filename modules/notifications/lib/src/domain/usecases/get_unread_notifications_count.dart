import 'package:core/core.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

class GetUnreadNotificationsCount extends UsecaseWithoutParams<int> {
  const new(this._repo);

  final NotificationsRepository _repo;

  @override
  ResultFuture<int> call() => _repo.getUnreadCount();
}
