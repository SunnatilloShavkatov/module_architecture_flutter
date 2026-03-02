import 'package:payments/src/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.cardLast4,
    required super.cardBrand,
    required super.expiryDate,
    required super.isDefault,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) => PaymentMethodModel(
    id: map['id'] ?? 0,
    cardLast4: map['cardLast4'] ?? '',
    cardBrand: map['cardBrand'] ?? '',
    expiryDate: map['expiryDate'] ?? '',
    isDefault: map['isDefault'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'cardLast4': cardLast4,
    'cardBrand': cardBrand,
    'expiryDate': expiryDate,
    'isDefault': isDefault,
  };
}
