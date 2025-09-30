import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:system/src/presentation/internet_connection/internet_connection_page.dart';

final class SystemRouter implements AppRouter {
  const SystemRouter();

  @override
  Map<String, ModalRoute<dynamic>> getRoutes(RouteSettings settings, Injector di) => {
    Routes.noInternet: MaterialPageRoute(settings: settings, builder: (_) => const InternetConnectionPage()),
  };
}
