part of '../login_page.dart';

mixin LoginMixin on State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _rememberMe = false;
  String? _errorMessage;

  LoginBloc get _bloc => context.read<LoginBloc>();

  String? emailValidator(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Email required';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Password required';
    }
    return null;
  }

  void togglePasswordVisibility() {
    setState(() => _isPasswordObscured = !_isPasswordObscured);
  }

  void setRememberMe({required bool isChecked}) {
    setState(() => _rememberMe = isChecked);
  }

  void stateListener(BuildContext context, LoginState state) {
    if (state is LoginFailure) {
      setState(() => _errorMessage = state.message);
      return;
    }
    if (state is LoginSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tizimga muvaffaqiyatli kirildi: ${state.auth.email}')));
      context.goNamed(Routes.mainHome);
    }
  }

  void loginPressed() {
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
