part of 'notifications_remote_data_source.dart';

final class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const new(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<List<NotificationModel>> getNotifications({required int page, int limit = Constants.defaultPageLimit}) async {
    try {
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        NotificationsApiPaths.clientNotifications,
        methodType: RMethodTypes.get,
        queryParameters: {'page': page, 'limit': limit},
      );
      final List<NotificationModel> notifications = [];
      if (result.data != null && result.data is List) {
        for (final notification in result.data!) {
          if (notification is Map) {
            notifications.add(NotificationModel.fromMap(Map<String, dynamic>.from(notification)));
          }
        }
      }
      return notifications;
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR getNotifications: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      }
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }
  }

  @override
  Future<void> markAsRead({required String id}) async {
    try {
      await _networkProvider.fetchMethod<dynamic>(
        NotificationsApiPaths.markAsRead.replaceAll('{id}', id),
        methodType: RMethodTypes.patch,
      );
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR markAsRead: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      }
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _networkProvider.fetchMethod<dynamic>(NotificationsApiPaths.clearAll, methodType: RMethodTypes.delete);
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR clearAll: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      }
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        NotificationsApiPaths.unreadCount,
        methodType: RMethodTypes.get,
      );
      final count = result.data?['count'];
      if (count is int) {
        return count;
      }
      if (count is num) {
        return count.toInt();
      }
      return 0;
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR getUnreadCount: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      }
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }
  }
}
