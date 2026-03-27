part of '../add_card_page.dart';

mixin AddCardMixin on State<AddCardPage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController = TextEditingController();
  late final TextEditingController _expiryController = TextEditingController();

  void _handleStates(BuildContext context, PaymentMethodsState state) {
    if (state is PaymentMethodsFailureState) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is PaymentMethodsSuccessState || state is PaymentMethodsActionSuccessState) {
      context.pop(true);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
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
