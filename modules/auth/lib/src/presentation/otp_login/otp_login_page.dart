import 'package:auth/src/presentation/otp_login/bloc/otp_login_bloc.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_event.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_state.dart';
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

part 'mixin/otp_login_mixin.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> with OtpLoginMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<OtpLoginBloc, OtpLoginState>(
    listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
    listener: stateListener,
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
                  Text('Handbook', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                  Dimensions.kGap8,
                  Text('OTP orqali kirish', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                  Dimensions.kGap8,
                  const Text('Telegram botdan olingan kodni kiriting', textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: openTelegramBot,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.color.primary.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.telegram, color: context.color.primary),
                          const SizedBox(width: 8),
                          Text('Kodni olish (Telegram)', style: TextStyle(color: context.color.primary)),
                        ],
                      ),
                    ),
                  ),
                  Dimensions.kGap16,
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tasdiqlash kodi',
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
                    isLoading: state is OtpLoginLoading,
                    onPressed: submitOtp,
                    child: const Text('Kirish'),
                  ),
                  Dimensions.kGap8,
                  TextButton(onPressed: goBackToLogin, child: const Text('Email orqali kirish')),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
