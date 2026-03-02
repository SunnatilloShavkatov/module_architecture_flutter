import 'package:core/core.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';

abstract interface class PaymentsRepository {
  const PaymentsRepository();

  ResultFuture<List<PaymentMethodEntity>> getPaymentMethods();

  ResultFuture<PaymentMethodEntity> addPaymentMethod({
    required String cardNumber,
    required String cardLast4,
    required String cardBrand,
    required String expiryDate,
    required bool isDefault,
  });

  ResultFeatureVoid deletePaymentMethod({required int id});
}
