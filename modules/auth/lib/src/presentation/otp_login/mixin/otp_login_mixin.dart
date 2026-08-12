part of '../otp_login_page.dart';

mixin OtpLoginMixin on State<OtpLoginPage> {
  late final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  OtpLoginBloc get _bloc => context.read<OtpLoginBloc>();

  Future<void> openTelegramBot() async {
    final Uri url = Uri.parse(AppEnvironment.instance.config.telegramBotUrl);
    final bool opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (opened || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Telegram ilovasini ochib bo'lmadi")));
  }

  void _handleStates(BuildContext context, OtpLoginState state) {
    if (state is OtpLoginFailure) {
      _errorMessage = state.message;
    } else if (state is OtpLoginSuccess) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tizimga muvaffaqiyatli kirildi: ${state.auth.email}')));
      context.goNamed(Routes.mainHome);
    }
  }

  void submitOtp() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      // setState needed here: no bloc event fires on this path, so nothing
      // else triggers a rebuild — this is the only way _errorMessage shows up.
      setState(() => _errorMessage = 'Tasdiqlash kodi majburiy');
      return;
    }
    // No setState here: the OtpLoginSubmitEvent below leads to a state
    // emission that BlocConsumer's builder (no buildWhen filter) already
    // rebuilds on, so it picks up _errorMessage = null on its own.
    _errorMessage = null;
    _bloc.add(OtpLoginSubmitEvent(code: code));
  }

  void goBackToLogin() {
    context.pop();
  }
}
