import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:module_architecture_flutter/routes/app_routes.dart";
import "package:navigation/navigation.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Flutter Demo",
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: Routes.splash,
        onGenerateRoute: AppRoutes.getRoutes,
      );
}
