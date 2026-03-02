import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:payments/src/presentation/payment_methods/bloc/payment_methods_bloc.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController = TextEditingController();
  late final TextEditingController _expiryController = TextEditingController();

  @override
  Widget build(BuildContext context) => BlocConsumer<PaymentMethodsBloc, PaymentMethodsState>(
    listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
    listener: (context, state) {
      if (state is PaymentMethodsFailureState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is PaymentMethodsSuccessState || state is PaymentMethodsActionSuccessState) {
        context.pop(true);
      }
    },
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                validator: (value) => (value ?? '').replaceAll(' ', '').length < 16 ? 'Invalid card number' : null,
                decoration: const InputDecoration(labelText: 'Card Number', border: OutlineInputBorder()),
              ),
              Dimensions.kGap12,
              TextFormField(
                controller: _expiryController,
                validator: (value) => (value ?? '').trim().isEmpty ? 'Required' : null,
                decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)', border: OutlineInputBorder()),
              ),
              Dimensions.kGap24,
              CustomLoadingButton(
                isLoading: state is PaymentMethodsLoadingState,
                onPressed: _submit,
                child: const Text('Save Card'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final number = _numberController.text.replaceAll(' ', '').trim();
    final String cardBrand = number.startsWith('4')
        ? 'Visa'
        : number.startsWith('5')
        ? 'Mastercard'
        : 'Unknown';
    final String cardLast4 = number.length >= 4 ? number.substring(number.length - 4) : number;
    context.read<PaymentMethodsBloc>().add(
      PaymentMethodAddEvent(
        cardNumber: number,
        cardLast4: cardLast4,
        cardBrand: cardBrand,
        expiryDate: _expiryController.text.trim(),
        isDefault: false,
      ),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    super.dispose();
  }
}
