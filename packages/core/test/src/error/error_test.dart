import 'package:core/src/error/failure.dart';
import 'package:core/src/error/server_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('ServerFailure props correctly include message and statusCode', () {
      const failure = ServerFailure(message: 'Server Error', statusCode: 500);
      expect(failure.props, ['Server Error', 500]);
    });

    test('NoInternetFailure props correctly include message', () {
      const failure = NoInternetFailure(message: 'No Connection');
      expect(failure.props, ['No Connection']);
    });
  });

  group('ServerException', () {
    test('ServerException.withException handles status codes properly', () {
      final dioError = DioException(
        requestOptions: RequestOptions(headers: {'language': 'en'}),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      );

      final exception = ServerException.withException(error: dioError);
      expect(exception.statusCode, 404);
      // Depending on LocalizedMessages implementation, this may return a localized string.
    });

    test('ServerException correctly returns ServerFailure via getter', () {
      const exception = ServerException(message: 'Oops', statusCode: 400);
      final failure = exception.failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Oops');
    });

    test('ServerException.formatException returns localized message', () {
      final exception = ServerException.formatException(locale: 'en');
      expect(exception.message, isNotNull);
    });
  });
}
