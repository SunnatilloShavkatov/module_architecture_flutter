import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';

class _MockNotificationsRepository extends Mock implements NotificationsRepository;

void main() {
  late GetNotifications usecase;
  late _MockNotificationsRepository mockRepository;

  final tNotification = NotificationEntity(
    id: '1',
    title: 'Title',
    message: 'Message',
    timestamp: DateTime(2024, 6, 15),
    isRead: false,
    type: 'general',
  );

  final tNotifications = [tNotification];

  setUp(() {
    mockRepository = _MockNotificationsRepository();
    usecase = GetNotifications(mockRepository);
  });

  test('calls repository.getNotifications with params and returns result', () async {
    when(() => mockRepository.getNotifications(page: 1))
        .thenAnswer((_) async => Right<Failure, List<NotificationEntity>>(tNotifications));

    final result = await usecase(const GetNotificationsParams(page: 1));

    expect(result, Right<Failure, List<NotificationEntity>>(tNotifications));
    verify(() => mockRepository.getNotifications(page: 1)).called(1);
  });
}
