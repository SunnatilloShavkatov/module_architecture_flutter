import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:payments/src/di/payments_injection.dart';
import 'package:payments/src/router/payments_router.dart';

final class PaymentsContainer implements ModuleContainer {
  const PaymentsContainer();

  @override
  AppRouter<RouteBase> get router => const PaymentsRouter();

  @override
  Injection get injection => const PaymentsInjection();
}
