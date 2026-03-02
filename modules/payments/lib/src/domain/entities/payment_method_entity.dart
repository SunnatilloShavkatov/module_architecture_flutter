import 'package:core/core.dart' show Equatable;

class PaymentMethodEntity extends Equatable {
  const PaymentMethodEntity({
    required this.id,
    required this.cardLast4,
    required this.cardBrand,
    required this.expiryDate,
    required this.isDefault,
  });

  final int id;
  final String cardLast4;
  final String cardBrand;
  final String expiryDate;
  final bool isDefault;

  @override
  List<Object?> get props => [id, cardLast4, cardBrand, expiryDate, isDefault];
}
