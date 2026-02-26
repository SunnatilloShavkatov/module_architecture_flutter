import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:auth/src/presentation/login/bloc/login_event.dart';
import 'package:auth/src/presentation/login/bloc/login_state.dart';
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

part 'mixin/login_mixin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Handbook', textAlign: TextAlign.center, style: context.textTheme.headlineSmall),
                    Dimensions.kGap8,
                    Text('Tizimga kirish', textAlign: TextAlign.center, style: context.textTheme.titleLarge),
                    Dimensions.kGap8,
                    Text(
                      'Davom etish uchun hisobingizga kiring',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.color.textSecondary),
                    ),
                    Dimensions.kGap20,
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Electron pochta',
                        hintText: 'email@example.com',
                        filled: true,
                        fillColor: context.color.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: emailValidator,
                    ),
                    Dimensions.kGap12,
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: _isPasswordObscured,
                      decoration: InputDecoration(
                        labelText: 'Parol',
                        hintText: 'Parolni kiriting',
                        filled: true,
                        fillColor: context.color.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: togglePasswordVisibility,
                          icon: Icon(_isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        ),
                      ),
                      validator: passwordValidator,
                      onFieldSubmitted: (_) => loginPressed(),
                    ),
                    Dimensions.kGap12,
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: Dimensions.kBoxConstraints24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setRememberMe(isChecked: value ?? false),
                            activeColor: context.color.primary,
                          ),
                        ),
                        Dimensions.kGap8,
                        const Text('Eslab qolish'),
                      ],
                    ),
                    if (_errorMessage != null) ...[
                      Dimensions.kGap8,
                      Text(_errorMessage!, style: TextStyle(color: context.colorScheme.error)),
                    ],
                    Dimensions.kGap12,
                    CustomLoadingButton(
                      isLoading: state is LoginLoading,
                      onPressed: loginPressed,
                      child: const Text('Kirish'),
                    ),
                    Dimensions.kGap8,
                    TextButton(onPressed: _openOtpPage, child: const Text('Telegram orqali kirish')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
