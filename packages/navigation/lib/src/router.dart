import "package:flutter/cupertino.dart";

part "name_routes.dart";

abstract class AppRouter {
  const AppRouter();

  Map<String, PageRoute> getRoutes(RouteSettings settings);
}
