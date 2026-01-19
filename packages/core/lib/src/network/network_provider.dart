import 'dart:async';

import 'package:core/src/constants/env.dart' show AppEnvironment;
import 'package:core/src/enums/rest_types.dart';
import 'package:core/src/error/server_error.dart';
import 'package:core/src/local_source/local_source.dart';
import 'package:core/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@protected
CancelToken _cancelToken = CancelToken();

abstract class NetworkProvider {
  const NetworkProvider();

  Future<Response<T>> fetchMethod<T>(
    String path, {
    Object? data,
    String? contentType,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    required RMethodTypes methodType,
    Map<String, dynamic>? queryParameters,
  });

  Future<void> downloadFile({
    required String urlPath,
    required String savePath,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  });

  void cancelPreviousRequest();

  void changeEnv();

  void setLocaleHeaders();

  String? get locale;

  String? get accessToken;
}

final class NetworkProviderImpl extends NetworkProvider {
  const NetworkProviderImpl(this._dio, this._localSource);

  final Dio _dio;
  final LocalSource _localSource;

  @override
  void cancelPreviousRequest() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
  }

  @override
  void changeEnv() {
    _dio.options.baseUrl = AppEnvironment.instance.config.baseUrl;
    _dio.options.headers = {..._dio.options.headers, 'api-token': AppEnvironment.instance.config.apiToken};
  }

  @override
  void setLocaleHeaders() {
    if (_localSource.locale == null) {
      return;
    }
    _dio.options.headers = {..._dio.options.headers, 'Accept-Language': _localSource.locale};
  }

  @override
  Future<Response<T>> fetchMethod<T>(
    String path, {
    Object? data,
    String? contentType,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    required RMethodTypes methodType,
    Map<String, dynamic>? queryParameters,
  }) async {
    late Response<T> response;
    try {
      switch (methodType) {
        case RMethodTypes.head:
          response = await _dio.head<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _cancelToken,
            options: headers != null ? Options(headers: headers, contentType: contentType) : null,
          );
        case RMethodTypes.get:
          response = await _dio.get<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _cancelToken,
            options: headers != null ? Options(headers: headers, contentType: contentType) : null,
          );
        case RMethodTypes.post:
          response = await _dio.post<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _cancelToken,
            options: headers != null ? Options(headers: headers, contentType: contentType) : null,
          );
        case RMethodTypes.patch:
          response = await _dio.patch<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _cancelToken,
            options: headers != null ? Options(headers: headers, contentType: contentType) : null,
          );
        case RMethodTypes.put:
          response = await _dio.put<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _cancelToken,
            options: headers != null ? Options(headers: headers, contentType: contentType) : null,
          );
        case RMethodTypes.delete:
          response = await _dio.delete<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? _cancelToken,
            options: headers != null ? Options(headers: headers, contentType: contentType) : null,
          );
      }
      return response;
    } on DioException catch (error, stackTrace) {
      if (CancelToken.isCancel(error)) {
        logMessage('Request was cancelled: $path');
        throw ServerException.withException(error: error);
      } else {
        logMessage('Exception occurred: ', stackTrace: stackTrace, error: error);
        throw ServerException.withException(error: error);
      }
    } on Exception catch (error, stackTrace) {
      logMessage('Exception occurred: ', stackTrace: stackTrace, error: error);
      rethrow;
    }
  }

  @override
  Future<void> downloadFile({
    required String urlPath,
    required String savePath,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
    } on DioException catch (error, stackTrace) {
      if (CancelToken.isCancel(error)) {
        logMessage('Request was cancelled: $urlPath');
        throw ServerException.withException(error: error);
      } else {
        logMessage('Exception occurred: ', stackTrace: stackTrace, error: error);
        throw ServerException.withException(error: error);
      }
    }
  }

  // void _logErrorMessage(DioException err, StackTrace stackTrace) {
  //   if (isMacOS) {
  //     return;
  //   }
  //   final String? contentType = err.requestOptions.headers['content-type']?.toString();
  //   if (contentType != null && contentType.contains('multipart/form-data')) {
  //     logMessage('Multipart request, skipping error logging');
  //     return;
  //   }
  //   try {
  //     final Map<String, String> json = <String, String>{
  //       'app_version': _packageInfo.version,
  //       'platform': defaultTargetPlatform.name,
  //       'end_time': DateTime.now().toString(),
  //       'build_number': _packageInfo.buildNumber,
  //       if (_localSource.fullname.isNotEmpty) 'fullname': _localSource.fullname,
  //       if (_localSource.userUuid != null) 'user_uuid': _localSource.userUuid ?? '',
  //       'os_version': Platform.isAndroid
  //           ? (_deviceInfo as AndroidDeviceInfo).version.release
  //           : (_deviceInfo as IosDeviceInfo).systemVersion,
  //       'name': Platform.isAndroid
  //           ? '${(_deviceInfo as AndroidDeviceInfo).brand} ${_deviceInfo.model}'
  //           : (_deviceInfo as IosDeviceInfo).name,
  //       'request': {
  //         'method': err.requestOptions.method,
  //         'url': err.requestOptions.uri.toString(),
  //         'query_parameters': err.requestOptions.queryParameters,
  //         if (err.requestOptions.data != null) 'data': err.requestOptions.data.toString(),
  //       }.toString(),
  //       'dio_exception_type': err.type.name,
  //       'error_stack_trace': err.stackTrace.toString(),
  //       if (err.error != null) 'error': (err.error ?? '').toString(),
  //       if (err.response?.data != null) 'error_data': (err.response?.data ?? '').toString(),
  //       if (err.response?.statusCode != null) 'status_code': (err.response?.statusCode ?? 0).toString(),
  //     };
  //     AnalyticsService.instance.reportEvent(AnalyticsKeys.networkError, parameters: json);
  //   } on Exception catch (e) {
  //     logMessage('Analytics error: ', stackTrace: stackTrace, error: e);
  //   }
  // }

  @override
  String? get locale => _localSource.locale;

  @override
  String? get accessToken => _dio.options.headers['Authorization'];
}
