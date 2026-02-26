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

  void setAccessToken(String token);

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
  void setAccessToken(String token) {
    _dio.options.headers = {..._dio.options.headers, 'Authorization': 'Bearer $token'};
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

  @override
  String? get locale => _localSource.locale;

  @override
  String? get accessToken => _dio.options.headers['Authorization'];
}
