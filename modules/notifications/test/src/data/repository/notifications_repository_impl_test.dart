import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/data/datasource/notifications_local_data_source.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/data/models/notification_model.dart';
import 'package:notifications/src/data/repository/notifications_repository_impl.dart';

class _MockRemoteDataSource extends Mock implements NotificationsRemoteDataSource;

class _MockLocalDataSource extends Mock implements NotificationsLocalDataSource;

void main() {
  late NotificationsRepositoryImpl repository;
  late _MockRemoteDataSource mockRemoteDataSource;
  late _MockLocalDataSource mockLocalDataSource;

  final tModel = NotificationModel(
    id: '1',
    title: 'Title',
    message: 'Message',
    timestamp: DateTime(2024, 6, 15),
    isRead: false,
    type: 'general',
  );

  setUp(() {
    mockRemoteDataSource = _MockRemoteDataSource();
    mockLocalDataSource = _MockLocalDataSource();
    repository = NotificationsRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  test('getNotifications returns Right(List<NotificationEntity>) on remote success', () async {
    when(() => mockRemoteDataSource.getNotifications(page: 1)).thenAnswer((_) async => [tModel]);

    final result = await repository.getNotifications(page: 1);

    expect(result.isRight, isTrue);
    result.fold((_) => fail('Should not fail'), (data) => expect(data.length, 1));
  });

  test('markAsRead returns Right(unit) on remote success', () async {
    when(() => mockRemoteDataSource.markAsRead(id: '1')).thenAnswer((_) async {});

    final result = await repository.markAsRead(id: '1');

    expect(result, const Right<Failure, Unit>(unit));
  });

  test('clearAll returns Right(unit) on remote success', () async {
    when(() => mockRemoteDataSource.clearAll()).thenAnswer((_) async {});

    final result = await repository.clearAll();

    expect(result, const Right<Failure, Unit>(unit));
  });

  test('getUnreadCount returns Right(int) on remote success', () async {
    when(() => mockRemoteDataSource.getUnreadCount()).thenAnswer((_) async => 3);

    final result = await repository.getUnreadCount();

    expect(result, const Right<Failure, int>(3));
  });
}
