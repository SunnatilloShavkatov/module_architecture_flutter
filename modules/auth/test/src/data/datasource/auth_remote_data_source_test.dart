import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNetworkProvider extends Mock implements NetworkProvider {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late _MockNetworkProvider mockNetwork;

  setUpAll(() {
    registerFallbackValue(RMethodTypes.post);
  });

  setUp(() {
    mockNetwork = _MockNetworkProvider();
    dataSource = AuthRemoteDataSourceImpl(mockNetwork);
    when(() => mockNetwork.locale).thenReturn('en');
    when(() => mockNetwork.setAccessToken(any())).thenReturn(null);
  });

  group('AuthRemoteDataSourceImpl', () {
    test('login returns UserModel on success', () async {
      when(
        () => mockNetwork.fetchMethod<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          methodType: any(named: 'methodType'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(),
          data: {'id': 1, 'email': 't@t.com', 'token': 's'},
          statusCode: 200,
        ),
      );

      final result = await dataSource.login(email: 't@t.com', password: 'p');
      expect(result.id, 1);
      verify(() => mockNetwork.setAccessToken('s')).called(1);
    });

    test('otpLogin returns UserModel on success', () async {
      when(
        () => mockNetwork.fetchMethod<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          methodType: any(named: 'methodType'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(),
          data: {'id': 1, 'email': 't@t.com', 'token': 's'},
          statusCode: 200,
        ),
      );

      final result = await dataSource.otpLogin(code: '123456');
      expect(result.id, 1);
      verify(() => mockNetwork.setAccessToken('s')).called(1);
    });
    group('Error handling', () {
      test('login throws ServerException on error', () {
        when(
          () => mockNetwork.fetchMethod<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            methodType: any(named: 'methodType'),
          ),
        ).thenThrow(const ServerException(message: 'Error', statusCode: 500));

        expect(() => dataSource.login(email: 't@t.com', password: 'p'), throwsA(isA<ServerException>()));
      });
    });
  });
}
