part of 'payments_remote_data_source.dart';

final class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  const PaymentsRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        PaymentsApiPaths.clientPaymentMethods,
        methodType: RMethodTypes.get,
      );
      final List<PaymentMethodModel> paymentMethods = [];
      if (result.data != null && result.data is List) {
        for (final paymentMethod in result.data!) {
          paymentMethods.add(PaymentMethodModel.fromMap(Map<String, dynamic>.from(paymentMethod as Map)));
        }
      }
      return paymentMethods;
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

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String cardNumber,
    required String cardLast4,
    required String cardBrand,
    required String expiryDate,
    required bool isDefault,
  }) async {
    try {
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        PaymentsApiPaths.clientPaymentMethods,
        methodType: RMethodTypes.post,
        data: {
          'cardNumber': cardNumber,
          'cardLast4': cardLast4,
          'cardBrand': cardBrand,
          'expiryDate': expiryDate,
          'isDefault': isDefault,
        },
      );
      return PaymentMethodModel.fromMap(result.data ?? {});
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

  @override
  Future<void> deletePaymentMethod({required int id}) async {
    try {
      await _networkProvider.fetchMethod<dynamic>(
        PaymentsApiPaths.clientPaymentMethodById(id),
        methodType: RMethodTypes.delete,
      );
      return;
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
