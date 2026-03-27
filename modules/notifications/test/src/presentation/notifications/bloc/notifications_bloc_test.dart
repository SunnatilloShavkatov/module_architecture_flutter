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

  final tNotification = NotificationEntity(
    id: '1',
    title: 'Test Title',
    message: 'Test Message',
    timestamp: DateTime(2024),
    isRead: false,
    type: 'general',
  );
  final tNotifications = [tNotification];
  const tFailure = ServerFailure(message: 'Server error');

  setUp(() {
    mockGetNotifications = _MockGetNotifications();
    notificationsBloc = NotificationsBloc(mockGetNotifications);
  });

  tearDown(() => notificationsBloc.close());

  test('initial state is NotificationsInitialState', () {
    expect(notificationsBloc.state, const NotificationsInitialState());
  });

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsSuccessState] on success',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => Right(tNotifications));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [const NotificationsLoadingState(), NotificationsSuccessState(notifications: tNotifications)],
    verify: (_) {
      verify(() => mockGetNotifications()).called(1);
    },
  );

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsFailureState] on failure',
    build: () {
      when(() => mockGetNotifications()).thenAnswer((_) async => const Left(tFailure));
      return notificationsBloc;
    },
    act: (bloc) => bloc.add(const NotificationsLoadEvent()),
    expect: () => [const NotificationsLoadingState(), const NotificationsFailureState(message: 'Server error')],
  );
}
