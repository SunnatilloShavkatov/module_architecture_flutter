import 'package:auth/src/presentation/otp_login/bloc/otp_login_bloc.dart';
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

part 'mixin/otp_login_mixin.dart';

class OtpLoginPage extends StatefulWidget {
  const new({super.key});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> with OtpLoginMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<OtpLoginBloc, OtpLoginState>(
    listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
    listener: _handleStates,
    builder: (context, state) => Scaffold(
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: Dimensions.kPaddingAll24,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: Dimensions.kRadius20,
                boxShadow: [
                  BoxShadow(
                    color: context.color.onBackground.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(context.l10n.appName, textAlign: TextAlign.center, style: context.textTheme.headlineSmall),
                  Dimensions.kGap8,
                  Text(context.l10n.otpLoginTitle, textAlign: TextAlign.center, style: context.textTheme.titleLarge),
                  Dimensions.kGap8,
                  Text(context.l10n.otpEnterCodeHint, textAlign: TextAlign.center),
                  Dimensions.kGap20,
                  InkWell(
                    onTap: openTelegramBot,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: Dimensions.kPaddingHor16Ver12,
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.color.primary.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.telegram, color: context.color.primary),
                          Dimensions.kGap8,
                          Text(context.l10n.getCodeViaTelegram, style: TextStyle(color: context.color.primary)),
                        ],
                      ),
                    ),
                  ),
                  Dimensions.kGap16,
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.otpCodeLabel,
                      hintText: '123456',
                      filled: true,
                      fillColor: context.color.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => submitOtp(),
                  ),
                  if (_errorMessage != null) ...[
                    Dimensions.kGap8,
                    Text(_errorMessage!, style: TextStyle(color: context.colorScheme.error)),
                  ],
                  Dimensions.kGap16,
                  CustomLoadingButton(
                    isLoading: state is OtpLoginLoadingState,
                    onPressed: submitOtp,
                    child: Text(context.l10n.loginButton),
                  ),
                  Dimensions.kGap8,
                  TextButton(onPressed: goBackToLogin, child: Text(context.l10n.loginViaEmail)),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
