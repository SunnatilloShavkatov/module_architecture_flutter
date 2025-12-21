import 'package:core/src/core_abstractions/injector.dart';
import 'package:go_router/go_router.dart';

abstract interface class AppRouter {
  const AppRouter();

  List<RouteBase> getRouters(Injector di);
}
