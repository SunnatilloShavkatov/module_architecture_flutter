import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/usecases/clear_all_notifications.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/domain/usecases/mark_notification_as_read.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';

class _MockGetNotifications extends Mock implements GetNotifications;

class _MockMarkNotificationAsRead extends Mock implements MarkNotificationAsRead;

class _MockClearAllNotifications extends Mock implements ClearAllNotifications;

void main() {
  setUpAll(() {
    registerFallbackValue(const GetNotificationsParams(page: 1));
    registerFallbackValue(const MarkNotificationParams(id: 'fallback'));
  });

  late NotificationsBloc notificationsBloc;
  late _MockGetNotifications mockGetNotifications;
  late _MockMarkNotificationAsRead mockMarkNotificationAsRead;
  late _MockClearAllNotifications mockClearAllNotifications;

  final tNotification1 = NotificationEntity(
    id: '1',
    title: 'Test Notification',
    message: 'Test message',
    timestamp: DateTime(2024, 6, 1, 9),
    isRead: false,
    type: 'appointment',
  );
  final tNotifications = [tNotification1];
  const tServerFailure = ServerFailure(message: 'Server error');

  setUp(() {
    mockGetNotifications = _MockGetNotifications();
    mockMarkNotificationAsRead = _MockMarkNotificationAsRead();
    mockClearAllNotifications = _MockClearAllNotifications();
    notificationsBloc = NotificationsBloc(mockGetNotifications, mockMarkNotificationAsRead, mockClearAllNotifications);
  });

  tearDown(() => notificationsBloc.close());

  test('initial state is NotificationsInitialState', () {
    expect(notificationsBloc.state, const NotificationsInitialState());
  });

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsLoadedState] on GetNotificationsEvent success',
    build: () {
      when(() => mockGetNotifications(any())).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const GetNotificationsEvent()),
    expect: () => [const NotificationsLoadingState(), NotificationsLoadedState(notifications: tNotifications)],
    verify: (_) => verify(() => mockGetNotifications(const GetNotificationsParams(page: 1))).called(1),
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsFailureState] on GetNotificationsEvent failure',
    build: () {
      when(() => mockGetNotifications(any())).thenAnswer((_) async => const Left(tServerFailure));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const GetNotificationsEvent()),
    expect: () => [const NotificationsLoadingState(), const NotificationsFailureState(message: 'Server error')],
    verify: (_) => verify(() => mockGetNotifications(const GetNotificationsParams(page: 1))).called(1),
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsPaginationLoadingState, NotificationsPaginationLoadedState] on GetPaginatedNotificationsEvent success',
    build: () {
      when(() => mockGetNotifications(any())).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const GetPaginatedNotificationsEvent(page: 2)),
    expect: () => [
      const NotificationsPaginationLoadingState(),
      NotificationsPaginationLoadedState(notifications: tNotifications),
    ],
    verify: (_) => verify(() => mockGetNotifications(const GetNotificationsParams(page: 2))).called(1),
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationActionLoadingState, NotificationMarkReadSuccessState] on MarkNotificationAsReadEvent success',
    build: () {
      when(() => mockMarkNotificationAsRead(any())).thenAnswer((_) async => const Right(unit));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const MarkNotificationAsReadEvent(id: '1')),
    expect: () => [const NotificationActionLoadingState(), const NotificationMarkReadSuccessState(id: '1')],
    verify: (_) => verify(() => mockMarkNotificationAsRead(const MarkNotificationParams(id: '1'))).called(1),
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationActionLoadingState, NotificationClearAllSuccessState] on ClearAllNotificationsEvent success',
    build: () {
      when(() => mockClearAllNotifications()).thenAnswer((_) async => const Right(unit));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const ClearAllNotificationsEvent()),
    expect: () => [const NotificationActionLoadingState(), const NotificationClearAllSuccessState()],
    verify: (_) => verify(() => mockClearAllNotifications()).called(1),
  );
}
