final class PaymentsApiPaths {
  const new _();

  static const String clientPaymentMethods = '/api/payment-methods/client';

  static String clientPaymentMethodById(int id) => '/api/payment-methods/$id/client';
}
