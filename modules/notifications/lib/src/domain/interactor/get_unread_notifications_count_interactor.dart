import 'package:core/core.dart';
import 'package:notifications/src/domain/usecases/get_unread_notifications_count.dart';

final class GetUnreadNotificationsCountInteractor implements ModuleInteractor<int, NoParams> {
  const new(this._getUnreadNotificationsCount);

  final GetUnreadNotificationsCount _getUnreadNotificationsCount;

  @override
  Future<Either<Failure, int>> call(NoParams params) => _getUnreadNotificationsCount();
}
