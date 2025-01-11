import "package:core/src/core_abstractions/injector.dart";
import "package:flutter/material.dart";

abstract class AppRouter {
  const AppRouter();

  Map<String, PageRoute> getRoutes(RouteSettings settings, Injector di);
}
