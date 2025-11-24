import 'package:auth/src/presentation/confirm/confirm_code_page.dart';
import 'package:auth/src/presentation/forgot/forgot_password_page.dart';
import 'package:auth/src/presentation/login/login_page.dart';
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class AuthRouter implements AppRouter {
  const AuthRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(path: Routes.login, name: Routes.login, builder: (context, state) => const LoginPage()),
    GoRoute(
      path: Routes.forgotPassword,
      name: Routes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(path: Routes.confirmCode, name: Routes.confirmCode, builder: (context, state) => const ConfirmCodePage()),
  ];
}
