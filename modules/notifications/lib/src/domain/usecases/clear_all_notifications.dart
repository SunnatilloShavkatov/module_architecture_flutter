import 'package:core/core.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

class ClearAllNotifications extends UsecaseWithoutParams<Unit> {
  const new(this._repo);

  final NotificationsRepository _repo;

  @override
  ResultFuture<Unit> call() => _repo.clearAll();
}
