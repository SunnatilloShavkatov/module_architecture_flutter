import 'package:core/core.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';
import 'package:payments/src/domain/repository/payments_repository.dart';

class AddPaymentMethod extends UsecaseWithParams<PaymentMethodEntity, AddPaymentMethodParams> {
  const AddPaymentMethod(this._repo);

  final PaymentsRepository _repo;

  @override
  ResultFuture<PaymentMethodEntity> call(AddPaymentMethodParams params) => _repo.addPaymentMethod(
    cardNumber: params.cardNumber,
    cardLast4: params.cardLast4,
    cardBrand: params.cardBrand,
    expiryDate: params.expiryDate,
    isDefault: params.isDefault,
  );
}

final class AddPaymentMethodParams {
  const AddPaymentMethodParams({
    required this.cardNumber,
    required this.cardLast4,
    required this.cardBrand,
    required this.expiryDate,
    required this.isDefault,
  });

  final String cardNumber;
  final String cardLast4;
  final String cardBrand;
  final String expiryDate;
  final bool isDefault;
}
