import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/di/profile_injection.dart';
import 'package:profile/src/router/profile_router.dart';

final class ProfileContainer implements ModuleContainer {
  const ProfileContainer();

  @override
  AppRouter<RouteBase> get router => const ProfileRouter();

  @override
  Injection get injection => const ProfileInjection();
}
