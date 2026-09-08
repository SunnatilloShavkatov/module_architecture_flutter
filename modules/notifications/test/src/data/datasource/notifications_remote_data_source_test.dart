import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/data/datasource/notifications_api_paths.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';

class _MockNetworkProvider extends Mock implements NetworkProvider;

void main() {
  late NotificationsRemoteDataSource dataSource;
  late _MockNetworkProvider mockNetworkProvider;

  setUp(() {
    mockNetworkProvider = _MockNetworkProvider();
    when(() => mockNetworkProvider.locale).thenReturn('en');
    dataSource = NotificationsRemoteDataSourceImpl(mockNetworkProvider);
  });

  test('getNotifications returns list of models on success', () async {
    when(
      () => mockNetworkProvider.fetchMethod<List<dynamic>>(
        NotificationsApiPaths.clientNotifications,
        methodType: RMethodTypes.get,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: [
          {'id': '1', 'title': 'Title 1', 'message': 'Msg 1', 'isRead': false, 'type': 'general'},
        ],
      ),
    );

    final result = await dataSource.getNotifications(page: 1);

    expect(result.length, 1);
    expect(result.first.id, '1');
    expect(result.first.title, 'Title 1');
  });

  test('getNotifications throws ServerException on FormatException', () {
    when(
      () => mockNetworkProvider.fetchMethod<List<dynamic>>(
        NotificationsApiPaths.clientNotifications,
        methodType: RMethodTypes.get,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(const FormatException('Bad format'));

    expect(() => dataSource.getNotifications(page: 1), throwsA(isA<ServerException>()));
  });

  test('markAsRead executes patch method', () async {
    when(
      () => mockNetworkProvider.fetchMethod<dynamic>(
        NotificationsApiPaths.markAsRead.replaceAll('{id}', '123'),
        methodType: RMethodTypes.patch,
      ),
    ).thenAnswer((_) async => Response(requestOptions: RequestOptions()));

    await expectLater(dataSource.markAsRead(id: '123'), completes);
  });

  test('clearAll executes delete method', () async {
    when(
      () => mockNetworkProvider.fetchMethod<dynamic>(NotificationsApiPaths.clearAll, methodType: RMethodTypes.delete),
    ).thenAnswer((_) async => Response(requestOptions: RequestOptions()));

    await expectLater(dataSource.clearAll(), completes);
  });

  test('getUnreadCount returns integer count', () async {
    when(
      () => mockNetworkProvider.fetchMethod<Map<String, dynamic>>(
        NotificationsApiPaths.unreadCount,
        methodType: RMethodTypes.get,
      ),
    ).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: {'count': 5}));

    final count = await dataSource.getUnreadCount();
    expect(count, 5);
  });
}
