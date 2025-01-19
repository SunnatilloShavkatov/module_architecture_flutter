import 'dart:async';
import 'dart:io';

import 'package:base_dependencies/base_dependencies.dart';

part 'http_status_codes.dart';

typedef RetryEvaluator = FutureOr<bool> Function(DioException error, int attempt);
typedef RefreshTokenFunction = Future<void> Function();
typedef CertificateVerifyFailedFunction = Future<void> Function();
typedef AccessTokenGetter = String Function();
typedef ForbiddenFunction = Future<void> Function();
typedef ToNoInternetPageNavigator = Future<void> Function();

/// An interceptor that will try to send failed request again
class RetryInterceptor extends InterceptorsWrapper {
  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 1,
    this.refreshTokenFunction,
    this.accessTokenGetter,
    this.forbiddenFunction,
    required this.certificateVerifyFailedFunction,
    required this.toNoInternetPageNavigator,
    this.retryDelays = const <Duration>[Duration(seconds: 1)],
  });

  /// The original dio
  final Dio dio;

  /// certificate verify failed functions get api client
  final CertificateVerifyFailedFunction certificateVerifyFailedFunction;

  ///refresh token functions get api client
  final RefreshTokenFunction? refreshTokenFunction;

  ///refresh token functions get api client
  final ForbiddenFunction? forbiddenFunction;

  /// Access token getter from storage
  final AccessTokenGetter? accessTokenGetter;

  /// ToNoInternetPage navigate
  final ToNoInternetPageNavigator toNoInternetPageNavigator;

  /// For logging purpose
  final void Function(String message) logPrint;

  /// The number of retry in case of an error
  final int retries;

  /// The delays between attempts.
  /// Empty [retryDelays] means no delay.
  ///
  /// If [retries] count more than [retryDelays] count,
  /// the last value of [retryDelays] will be used.
  final List<Duration> retryDelays;

  /// Returns true only if the response hasn't been cancelled or got
  /// a bas status code.
  Future<bool> defaultRetryEvaluator(DioException error, int attempt) async {
    bool shouldRetry = false;
    if (error.type == DioExceptionType.unknown && error.error is HandshakeException) {
      await certificateVerifyFailedFunction.call();
      shouldRetry = true;
    } else if (error.type == DioExceptionType.badResponse) {
      final int statusCode = error.response?.statusCode ?? 500;
      shouldRetry = isRetryAble(statusCode);
      if (statusCode == 401) {
        await refreshTokenFunction?.call();
        shouldRetry = true;
      } else if (statusCode == 403) {
        await forbiddenFunction?.call();
        shouldRetry = true;
      }
    } else if (error.type == DioExceptionType.connectionError) {
      await toNoInternetPageNavigator();
      shouldRetry = true;
    } else {
      shouldRetry = false;
    }
    return shouldRetry;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.disableRetry) {
      return super.onError(err, handler);
    }
    final int attempt = err.requestOptions._attempt + 1;
    final bool shouldRetry = attempt <= retries && await defaultRetryEvaluator(err, attempt);

    if (!shouldRetry) {
      return super.onError(err, handler);
    }

    err.requestOptions._attempt = attempt;
    final Duration delay = _getDelay(attempt);
    logPrint.call(
      '[${err.requestOptions.uri}] An error occurred during request, '
      'trying again '
      '(attempt: $attempt/$retries, '
      'wait ${delay.inMilliseconds} ms, '
      'error: ${err.error})',
    );

    if (delay != Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final Map<String, dynamic> header = <String, dynamic>{}..addAll(err.requestOptions.headers);
    if (accessTokenGetter != null) {
      header['Authorization'] = accessTokenGetter!();
    }
    err.requestOptions.headers = header;
    try {
      await dio.fetch<void>(err.requestOptions).then((Response<void> value) => handler.resolve(value));
    } on DioException catch (e, s) {
      logPrint('error: $e $s');
      super.onError(e, handler);
    } on Exception catch (e, s) {
      logPrint('error: $e $s');
    }
  }

  Duration _getDelay(int attempt) {
    if (retryDelays.isEmpty) {
      return Duration.zero;
    }
    return attempt - 1 < retryDelays.length ? retryDelays[attempt - 1] : retryDelays.last;
  }
}

extension RequestOptionsX on RequestOptions {
  static const String _kAttemptKey = 'ro_attempt';
  static const String _kDisableRetryKey = 'ro_disable_retry';

  int get _attempt => extra[_kAttemptKey] ?? 0;

  set _attempt(int value) => extra[_kAttemptKey] = value;

  bool get disableRetry => (extra[_kDisableRetryKey] as bool?) ?? false;

  set disableRetry(bool value) => extra[_kDisableRetryKey] = value;
}
