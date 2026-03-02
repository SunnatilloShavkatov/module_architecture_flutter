import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:payments/src/presentation/add_card/add_card_page.dart';
import 'package:payments/src/presentation/payment_methods/bloc/payment_methods_bloc.dart';
import 'package:payments/src/presentation/payment_methods/payment_methods_page.dart';

final class PaymentsRouter implements AppRouter<RouteBase> {
  const PaymentsRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.paymentMethods,
      name: Routes.paymentMethods,
      builder: (_, _) => BlocProvider<PaymentMethodsBloc>(
        create: (_) => di.get<PaymentMethodsBloc>()..add(const PaymentMethodsLoadEvent()),
        child: const PaymentMethodsPage(),
      ),
    ),
    GoRoute(
      path: Routes.addCard,
      name: Routes.addCard,
      builder: (_, _) => BlocProvider<PaymentMethodsBloc>(create: (_) => di.get(), child: const AddCardPage()),
    ),
  ];
}
