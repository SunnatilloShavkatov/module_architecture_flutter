import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/domain/interactor/get_unread_notifications_count_interactor.dart';
import 'package:notifications/src/domain/usecases/get_unread_notifications_count.dart';

class _MockGetUnreadNotificationsCount extends Mock implements GetUnreadNotificationsCount;

void main() {
  late GetUnreadNotificationsCountInteractor interactor;
  late _MockGetUnreadNotificationsCount mockGetUnreadCount;

  setUp(() {
    mockGetUnreadCount = _MockGetUnreadNotificationsCount();
    interactor = GetUnreadNotificationsCountInteractor(mockGetUnreadCount);
  });

  test('calls usecase and returns unread count', () async {
    when(() => mockGetUnreadCount()).thenAnswer((_) async => const Right<Failure, int>(4));

    final result = await interactor(const NoParams());

    expect(result, const Right<Failure, int>(4));
    verify(() => mockGetUnreadCount()).called(1);
  });
}
