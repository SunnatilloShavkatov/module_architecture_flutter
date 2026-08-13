import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:payments/src/presentation/payment_methods/bloc/payment_methods_bloc.dart';

part 'mixin/add_card_mixin.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> with AddCardMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<PaymentMethodsBloc, PaymentMethodsState>(
    listenWhen: (prev, curr) =>
        curr is PaymentMethodsFailureState ||
        curr is PaymentMethodsSuccessState ||
        curr is PaymentMethodsActionSuccessState,
    listener: _handleStates,
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.addCard)),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value ?? '').replaceAll(' ', '').length < 16 ? context.l10n.invalidCardNumber : null,
                decoration: InputDecoration(
                  labelText: context.l10n.cardNumber,
                  border: const OutlineInputBorder(),
                ),
              ),
              Dimensions.kGap12,
              TextFormField(
                controller: _expiryController,
                validator: (value) => (value ?? '').trim().isEmpty ? context.l10n.fieldRequired : null,
                decoration: InputDecoration(
                  labelText: context.l10n.expiryDate,
                  border: const OutlineInputBorder(),
                ),
              ),
              Dimensions.kGap24,
              CustomLoadingButton(
                isLoading: state is PaymentMethodsLoadingState,
                onPressed: _submit,
                child: Text(context.l10n.saveCard),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
