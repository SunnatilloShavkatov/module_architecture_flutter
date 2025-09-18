import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:main/src/presentation/main/main_page.dart';
import 'package:navigation/navigation.dart';

final class MainRouter implements AppRouter {
  const MainRouter();

  @override
  Map<String, ModalRoute<dynamic>> getRoutes(RouteSettings settings, Injector di) => {
        Routes.main: MaterialPageRoute(settings: settings, builder: (_) => const MainPage()),
      };
}
