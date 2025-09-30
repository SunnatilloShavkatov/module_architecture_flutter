import 'package:core/core.dart';
import 'package:initial/src/router/initial_router.dart';

final class InitialContainer implements ModuleContainer {
  const InitialContainer();

  @override
  AppRouter get router => const InitialRouter();

  @override
  Injection? get injection => null;
}
