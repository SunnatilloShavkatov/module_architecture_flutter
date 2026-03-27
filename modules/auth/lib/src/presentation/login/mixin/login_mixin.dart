part of '../login_page.dart';

mixin LoginMixin on State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _rememberMe = false;
  String? _errorMessage;

  LoginBloc get _bloc => context.read<LoginBloc>();

  String? _emailValidator(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return context.localizations.emailRequired;
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return context.localizations.passwordRequired;
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordObscured = !_isPasswordObscured);
  }

  void _setRememberMe({required bool isChecked}) {
    setState(() => _rememberMe = isChecked);
  }

  void _handleStates(BuildContext context, LoginState state) {
    if (state is LoginFailure) {
      setState(() => _errorMessage = state.message);
      return;
    } else if (state is LoginSuccess) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${context.localizations.loginSuccessMessage}: ${state.auth.email}')));
      context.goNamed(Routes.mainHome);
    }
  }

  void _loginPressed() {
    final currentForm = _formKey.currentState;
    if (currentForm == null || !currentForm.validate()) {
      return;
    }
    setState(() => _errorMessage = null);
    _bloc.add(LoginSubmitEvent(email: _emailController.text.trim(), password: _passwordController.text.trim()));
  }

  void _openOtpPage() {
    context.pushNamed(Routes.otpLogin).ignore();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
