import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

final class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(this._getNotifications) : super(const NotificationsInitialState()) {
    on<NotificationsLoadEvent>(_loadHandler);
  }

  final GetNotifications _getNotifications;

  Future<void> _loadHandler(NotificationsLoadEvent event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsLoadingState());
    final result = await _getNotifications();
    result.fold(
      (failure) => emit(NotificationsFailureState(message: failure.message)),
      (notifications) => emit(NotificationsSuccessState(notifications: notifications)),
    );
  }
}
