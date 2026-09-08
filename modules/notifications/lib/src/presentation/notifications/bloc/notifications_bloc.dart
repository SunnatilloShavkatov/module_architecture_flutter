import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/usecases/clear_all_notifications.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/domain/usecases/mark_notification_as_read.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

final class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  new(this._getNotifications, this._markAsRead, this._clearAll) : super(const NotificationsInitialState()) {
    on<GetNotificationsEvent>(_getNotificationsHandler, transformer: droppable());
    on<GetPaginatedNotificationsEvent>(_getPaginatedNotificationsHandler, transformer: droppable());
    on<MarkNotificationAsReadEvent>(_markNotificationAsReadHandler, transformer: throttle());
    on<ClearAllNotificationsEvent>(_clearAllNotificationsHandler, transformer: throttle());
  }

  final GetNotifications _getNotifications;
  final MarkNotificationAsRead _markAsRead;
  final ClearAllNotifications _clearAll;

  Future<void> _getNotificationsHandler(GetNotificationsEvent event, Emitter<NotificationsState> emit) async {
    if (state is NotificationsLoadingState) {
      return;
    }
    emit(const NotificationsLoadingState());
    final result = await _getNotifications(const GetNotificationsParams(page: 1));
    result.fold(
      (failure) => emit(NotificationsFailureState(message: failure.message)),
      (notifications) => emit(NotificationsLoadedState(notifications: notifications)),
    );
  }

  Future<void> _getPaginatedNotificationsHandler(
    GetPaginatedNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsPaginationLoadingState) {
      return;
    }
    emit(const NotificationsPaginationLoadingState());
    final result = await _getNotifications(GetNotificationsParams(page: event.page));
    result.fold(
      (failure) => emit(NotificationsFailureState(message: failure.message)),
      (notifications) => emit(NotificationsPaginationLoadedState(notifications: notifications)),
    );
  }

  Future<void> _markNotificationAsReadHandler(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationActionLoadingState());
    final result = await _markAsRead(MarkNotificationParams(id: event.id));
    result.fold(
      (failure) => emit(NotificationActionFailureState(message: failure.message)),
      (_) => emit(NotificationMarkReadSuccessState(id: event.id)),
    );
  }

  Future<void> _clearAllNotificationsHandler(ClearAllNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(const NotificationActionLoadingState());
    final result = await _clearAll();
    result.fold(
      (failure) => emit(NotificationActionFailureState(message: failure.message)),
      (_) => emit(const NotificationClearAllSuccessState()),
    );
  }
}
