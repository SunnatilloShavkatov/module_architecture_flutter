import 'package:core/core.dart';
import 'package:payments/src/data/datasource/payments_api_paths.dart';
import 'package:payments/src/data/models/payment_method_model.dart';

part 'payments_remote_data_source_impl.dart';

abstract interface class PaymentsRemoteDataSource {
  const PaymentsRemoteDataSource();

  Future<List<PaymentMethodModel>> getPaymentMethods();

  Future<PaymentMethodModel> addPaymentMethod({
    required String cardNumber,
    required String cardLast4,
    required String cardBrand,
    required String expiryDate,
    required bool isDefault,
  });

  ResultVoid deletePaymentMethod({required int id});
}
