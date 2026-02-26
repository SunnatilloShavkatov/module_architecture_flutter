part of '../otp_login_page.dart';

mixin OtpLoginMixin on State<OtpLoginPage> {
  static const String _telegramBotUrl = 'https://t.me/handbookuz_bot';

  late final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  OtpLoginBloc get _bloc => context.read<OtpLoginBloc>();

  Future<void> openTelegramBot() async {
    final Uri url = Uri.parse(_telegramBotUrl);
    final bool opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (opened || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Telegram ilovasini ochib bo'lmadi")));
  }

  void stateListener(BuildContext context, OtpLoginState state) {
    if (state is OtpLoginFailure) {
      setState(() => _errorMessage = state.message);
      return;
    }
    if (state is OtpLoginSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tizimga muvaffaqiyatli kirildi: ${state.auth.email}')));
      context.goNamed(Routes.mainHome);
    }
  }

  void submitOtp() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Tasdiqlash kodi majburiy');
      return;
    }
    setState(() => _errorMessage = null);
    _bloc.add(OtpLoginSubmitEvent(code: code));
  }

  void goBackToLogin() {
    context.pop();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
