import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';

class _MockGetNotifications extends Mock implements GetNotifications {}

void main() {
  late NotificationsBloc notificationsBloc;
  late _MockGetNotifications mockGetNotifications;

  final tNotification1 = NotificationEntity(
    id: '1',
    title: 'Appointment confirmed',
    message: 'Your appointment at 10:00 is confirmed',
    timestamp: DateTime(2024, 6, 1, 9),
    isRead: false,
    type: 'appointment',
  );
  final tNotification2 = NotificationEntity(
    id: '2',
    title: 'Promo',
    message: '20% off this weekend',
    timestamp: DateTime(2024, 6, 1, 8),
    isRead: true,
    type: 'promo',
  );
  final tNotifications = [tNotification1, tNotification2];
  const tServerFailure = ServerFailure(message: 'Server error');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet connection');

  setUp(() {
    mockGetNotifications = _MockGetNotifications();
    notificationsBloc = NotificationsBloc(mockGetNotifications);
  });

  tearDown(() => notificationsBloc.close());

  // ─── Initial state ────────────────────────────────────────────────────────────
  test('initial state is NotificationsInitialState', () {
    expect(notificationsBloc.state, const NotificationsInitialState());
  });

  // ─── Success with multiple notifications ─────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsSuccessState] with full list on success',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      NotificationsSuccessState(notifications: tNotifications),
    ],
    verify: (_) => verify(() => mockGetNotifications()).called(1),
  );

  // ─── Success with empty list ──────────────────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'emits NotificationsSuccessState with empty list when no notifications',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => const Right([]));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      const NotificationsSuccessState(notifications: []),
    ],
  );

  // ─── Server failure ───────────────────────────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsFailureState] on server failure',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => const Left(tServerFailure));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      const NotificationsFailureState(message: 'Server error'),
    ],
    verify: (_) => verify(() => mockGetNotifications()).called(1),
  );

  // ─── Network failure ──────────────────────────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsFailureState] on network failure',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => const Left(tNoInternetFailure));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      const NotificationsFailureState(message: 'No internet connection'),
    ],
  );

  // ─── Can reload after success ─────────────────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'can load again after NotificationsSuccessState',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    seed: () => const NotificationsSuccessState(notifications: []),
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      NotificationsSuccessState(notifications: tNotifications),
    ],
  );

  // ─── Can reload after failure ─────────────────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'can reload after NotificationsFailureState',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    seed: () => const NotificationsFailureState(message: 'Previous error'),
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      NotificationsSuccessState(notifications: tNotifications),
    ],
  );

  // ─── Usecase called exactly once per event ────────────────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'calls GetNotifications usecase exactly once per load event',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    verify: (_) => verify(() => mockGetNotifications()).called(1),
  );

  // ─── NotificationsSuccessState carries correct data ───────────────────────────
  blocTest<NotificationsBloc, NotificationsState>(
    'NotificationsSuccessState contains exact notifications from usecase',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => Right([tNotification1]));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    verify: (bloc) {
      final state = bloc.state as NotificationsSuccessState;
      expect(state.notifications.length, 1);
      expect(state.notifications.first.id, '1');
      expect(state.notifications.first.isRead, false);
    },
  );
}
