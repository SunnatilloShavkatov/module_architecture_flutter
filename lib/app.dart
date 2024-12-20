import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:module_architecture_flutter/router/app_routes.dart";
import "package:navigation/navigation.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        key: const Key("material_app"),
        title: "Module",
        onGenerateTitle: (_) => "Module",
        debugShowCheckedModeBanner: false,

        /// theme style
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: context.options.themeMode,
        themeAnimationCurve: Curves.easeInOut,
        themeAnimationDuration: const Duration(milliseconds: 300),
        themeAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          reverseCurve: Curves.easeInOut,
          reverseDuration: const Duration(milliseconds: 300),
        ),

        /// route
        initialRoute: Routes.splash,
        navigatorKey: AppRoutes.navigatorKey,
        onUnknownRoute: AppRoutes.unknownRoute,
        onGenerateRoute: AppRoutes.generateRoutes,
        navigatorObservers: [navigatorObserver],

        /// text scale factor
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: context.textScaler.clamp(minScaleFactor: 1, maxScaleFactor: 1.5),
          ),
          child: child ?? Dimensions.kGap,
        ),

        /// locale
        locale: context.options.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      );
}
