import 'package:core/src/error/failure.dart';
import 'package:core/src/l10n/localized_messages.dart';
import 'package:dio/dio.dart';

final class ServerException implements Exception {
  const ServerException({this.message, this.statusCode});

  factory ServerException.withException({required DioException error}) {
    int? statusCode;
    String? errorMessage;
    final String? locale = error.requestOptions.headers['language'];
    statusCode = error.response?.statusCode ?? 500;
    if (statusCode == 403 || statusCode == 401) {
      errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.tokenExpired, locale: locale);
      return ServerException(message: errorMessage, statusCode: statusCode);
    } else if (statusCode == 503 || statusCode == 502) {
      errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.serverError, locale: locale);
      return ServerException(message: errorMessage, statusCode: statusCode);
    } else if (statusCode == 404) {
      errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.notFound, locale: locale);
      return ServerException(message: errorMessage, statusCode: statusCode);
    } else if (statusCode == 413) {
      errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.requestEntityTooLarge, locale: locale);
      return ServerException(message: errorMessage, statusCode: statusCode);
    }
    switch (error.type) {
      case DioExceptionType.connectionError:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.connectionError, locale: locale);
      case DioExceptionType.connectionTimeout:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.connectionTimeout, locale: locale);
      case DioExceptionType.sendTimeout:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.sendTimeout, locale: locale);
      case DioExceptionType.receiveTimeout:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.receiveTimeout, locale: locale);
      case DioExceptionType.badResponse:
        {
          if (statusCode == 500) {
            if (error.response?.data is Map) {
              errorMessage = (error.response!.data as Map<String, dynamic>)['description'];
              return ServerException(message: errorMessage, statusCode: statusCode);
            }
            errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.serverError, locale: locale);
          } else if (error.response?.data is String) {
            errorMessage = error.response!.data;
          } else if (error.response?.data is Map<String, dynamic>) {
            final Map<String, dynamic> data = error.response!.data;
            if (data['errors'] is Map) {
              final Map<String, dynamic> errors = data['errors'];
              if (errors.isNotEmpty) {
                errorMessage = (errors['message'] ?? '').toString();
              }
            } else if (data['errors'] is List) {
              final List<dynamic> errors = data['errors'];
              if (errors.isNotEmpty) {
                final Map<String, dynamic> first = errors.first;
                errorMessage = first['message'].toString();
              }
            } else {
              errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.somethingWrong, locale: locale);
            }
          } else {
            errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.somethingWrong, locale: locale);
          }
          break;
        }
      case DioExceptionType.cancel:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.tokenExpired, locale: locale);
      case DioExceptionType.unknown:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.somethingWrong, locale: locale);
      case DioExceptionType.badCertificate:
        errorMessage = LocalizedMessages.instance.tr(LocalizationKeys.badCertificate, locale: locale);
    }
    return ServerException(message: errorMessage, statusCode: statusCode);
  }

  factory ServerException.withLocaleException({required String message, required String? locale}) =>
      ServerException(message: LocalizedMessages.instance.tr(message, locale: locale));

  factory ServerException.typeError({required String? locale}) =>
      ServerException(message: LocalizedMessages.instance.tr(LocalizationKeys.typeError, locale: locale));

  factory ServerException.formatException({required String? locale}) =>
      ServerException(message: LocalizedMessages.instance.tr(LocalizationKeys.formatException, locale: locale));

  factory ServerException.unknownError({required String? locale}) =>
      ServerException(message: LocalizedMessages.instance.tr(LocalizationKeys.unknownError, locale: locale));

  final int? statusCode;
  final String? message;

  ServerFailure get failure => ServerFailure(message: message ?? '', statusCode: statusCode);
}
