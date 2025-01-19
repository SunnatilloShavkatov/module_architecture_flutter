import 'dart:io';

import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/src/enums/rest_types.dart';
import 'package:core/src/error/server_error.dart';
import 'package:core/src/utils/utils.dart';
import 'package:flutter/material.dart';

@protected
CancelToken _cancelToken = CancelToken();

final class NetworkProvider {
  const NetworkProvider(this._dio);

  final Dio _dio;

  void cancelPreviousRequest() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
  }

  void removeRefreshTokenInterceptor() {
    _dio.interceptors.removeWhere((element) => element is QueuedInterceptorsWrapper);
  }

  Future<Response<T>> fetchMethodWithOptions<T>(RequestOptions options) async => _dio.fetch(options);

  Future<Response<T>> fetchMethod<T>(
    String path, {
    required RMethodTypes methodType,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    late Response<T> response;
    try {
      switch (methodType) {
        case RMethodTypes.get:
          response = await _dio.get<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.post:
          response = await _dio.post<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.patch:
          response = await _dio.patch<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.put:
          response = await _dio.put<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.delete:
          response = await _dio.delete<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
      }
      return response;
    } on DioException catch (error, stackTrace) {
      logMessage('Exception occurred: ', stackTrace: stackTrace, error: error);
      throw ServerError.withDioException(error: error);
    } on Exception catch (error, stackTrace) {
      logMessage('Exception occurred: ', stackTrace: stackTrace, error: error);
      throw ServerError.withException(error: error);
    }
  }

  Future<dynamic> downloadFile({
    required String urlPath,
    required String savePath,
    void Function(int, int)? onReceiveProgress,
  }) async =>
      _dio.download(urlPath, savePath, onReceiveProgress: onReceiveProgress, cancelToken: _cancelToken);

  Future<Response<T>> uploadFile<T>(
    String path, {
    required File file,
    required String mediaType,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    required RMethodTypes methodType,
    Map<String, dynamic>? queryParameters,
  }) async {
    late Response<T> response;
    final data = FormData();
    data.files.add(
      MapEntry(
        'file',
        MultipartFile.fromFileSync(
          file.path,
          contentType: DioMediaType.parse(mediaType),
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      ),
    );
    try {
      switch (methodType) {
        case RMethodTypes.get:
          response = await _dio.get<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.post:
          response = await _dio.post<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.patch:
          response = await _dio.patch<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.put:
          response = await _dio.put<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
        case RMethodTypes.delete:
          response = await _dio.delete<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );
          return _dio.post(path);
      }
    } on DioException catch (e) {
      throw ServerError.withDioException(error: e);
    }
    return response;
  }
}
