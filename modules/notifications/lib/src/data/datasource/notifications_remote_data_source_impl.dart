part of 'notifications_remote_data_source.dart';

final class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        NotificationsApiPaths.clientNotifications,
        methodType: RMethodTypes.get,
      );
      final List<NotificationModel> notifications = [];
      if (result.data != null && result.data is List) {
        for (final notification in result.data!) {
          notifications.add(NotificationModel.fromMap(Map<String, dynamic>.from(notification as Map)));
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
      logMessage('ERROR: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      } else {
        throw ServerException.unknownError(locale: _networkProvider.locale);
      }
    }
  }
}
