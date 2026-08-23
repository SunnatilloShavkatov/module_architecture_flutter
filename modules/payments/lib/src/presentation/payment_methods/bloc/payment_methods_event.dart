part of 'payment_methods_bloc.dart';

sealed class PaymentMethodsEvent extends Equatable {
  const new();
}

final class PaymentMethodsLoadEvent extends PaymentMethodsEvent {
  const new();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodAddEvent extends PaymentMethodsEvent {
  const new({
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

  @override
  List<Object?> get props => [cardNumber, cardLast4, cardBrand, expiryDate, isDefault];
}

final class PaymentMethodDeleteEvent extends PaymentMethodsEvent {
  const new({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
