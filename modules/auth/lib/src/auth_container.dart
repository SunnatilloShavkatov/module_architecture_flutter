import 'package:auth/src/di/auth_injection.dart';
import 'package:auth/src/router/auth_router.dart';
import 'package:core/core.dart';

final class AuthContainer implements ModuleContainer {
  const AuthContainer();

  @override
  Injection? get injection => const AuthInjection();

  @override
  AppRouter? get router => const AuthRouter();
}
