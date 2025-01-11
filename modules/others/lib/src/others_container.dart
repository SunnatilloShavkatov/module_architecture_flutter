import "package:core/core.dart";
import "package:others/src/router/others_router.dart";

final class OthersContainer implements ModuleContainer {
  const OthersContainer();

  @override
  AppRouter get router => const OthersRouter();

  @override
  Injection? get injection => null;
}
