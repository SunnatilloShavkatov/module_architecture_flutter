import 'package:auth/src/presentation/confirm/confirm_code_page.dart';
import 'package:auth/src/presentation/forgot/forgot_password_page.dart';
import 'package:auth/src/presentation/login/login_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

final class AuthRouter implements AppRouter {
  const AuthRouter();

  @override
  Map<String, ModalRoute<dynamic>> getRoutes(RouteSettings settings, Injector di) => {
    Routes.login: MaterialPageRoute(settings: settings, builder: (_) => const LoginPage()),
    Routes.forgotPassword: MaterialPageRoute(settings: settings, builder: (_) => const ForgotPasswordPage()),
    Routes.confirmCode: MaterialPageRoute(settings: settings, builder: (_) => const ConfirmCodePage()),
  };
}
