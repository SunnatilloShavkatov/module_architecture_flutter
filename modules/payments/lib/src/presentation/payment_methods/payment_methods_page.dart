import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';
import 'package:payments/src/presentation/payment_methods/bloc/payment_methods_bloc.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<PaymentMethodsBloc, PaymentMethodsState>(
    listenWhen: (prev, curr) => curr is PaymentMethodsActionSuccessState || curr is PaymentMethodsFailureState,
    listener: (context, state) {
      if (state is PaymentMethodsFailureState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is PaymentMethodsActionSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      }
    },
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: switch (state) {
          PaymentMethodsInitialState() || PaymentMethodsLoadingState() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          PaymentMethodsFailureState() => _PaymentsFailureView(message: state.message),
          PaymentMethodsSuccessState() => _PaymentsContentView(paymentMethods: state.paymentMethods),
          PaymentMethodsActionSuccessState() => _PaymentsContentView(paymentMethods: state.paymentMethods),
        },
      ),
      bottomNavigationBar: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: CustomLoadingButton(
          onPressed: () async {
            final result = await context.pushNamed(Routes.addCard);
            if (result is bool && result && context.mounted) {
              context.read<PaymentMethodsBloc>().add(const PaymentMethodsLoadEvent());
            }
          },
          child: const Text('Add New Card'),
        ),
      ),
    ),
  );
}

final class _PaymentsFailureView extends StatelessWidget {
  const _PaymentsFailureView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      message,
      style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.error),
      textAlign: TextAlign.center,
    ),
  );
}

final class _PaymentsContentView extends StatelessWidget {
  const _PaymentsContentView({required this.paymentMethods});

  final List<PaymentMethodEntity> paymentMethods;

  @override
  Widget build(BuildContext context) {
    if (paymentMethods.isEmpty) {
      return const Center(child: Text('No payment methods'));
    }
    return ListView.separated(
      itemCount: paymentMethods.length,
      separatorBuilder: (_, _) => Dimensions.kGap12,
      itemBuilder: (_, index) {
        final method = paymentMethods[index];
        return Container(
          padding: Dimensions.kPaddingAll12,
          decoration: BoxDecoration(
            borderRadius: Dimensions.kBorderRadius12,
            border: Border.all(color: context.color.primary.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              const Icon(Icons.credit_card),
              Dimensions.kGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${method.cardBrand} ending in ${method.cardLast4}',
                      style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text('Expires ${method.expiryDate}', style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<PaymentMethodsBloc>().add(PaymentMethodDeleteEvent(id: method.id));
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        );
      },
    );
  }
}
