final class PaymentsApiPaths {
  const PaymentsApiPaths._();

  static const String clientPaymentMethods = '/api/payment-methods/client';

  static String clientPaymentMethodById(int id) => '/api/payment-methods/$id/client';
}
