import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:auth/src/presentation/login/login_page.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_bloc.dart';
import 'package:auth/src/presentation/otp_login/otp_login_page.dart';
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class AuthRouter implements AppRouter<RouteBase> {
  const AuthRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => BlocProvider<LoginBloc>(create: (_) => di.get(), child: const LoginPage()),
    ),
    GoRoute(
      path: Routes.otpLogin,
      name: Routes.otpLogin,
      builder: (context, state) => BlocProvider<OtpLoginBloc>(create: (_) => di.get(), child: const OtpLoginPage()),
    ),
  ];
}
