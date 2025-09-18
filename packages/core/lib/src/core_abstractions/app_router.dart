import 'package:core/src/core_abstractions/injector.dart';
import 'package:flutter/material.dart';

abstract interface class AppRouter {
  const AppRouter();

  Map<String, ModalRoute<dynamic>> getRoutes(RouteSettings settings, Injector di);
}
