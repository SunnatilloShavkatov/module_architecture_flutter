import 'package:flutter/material.dart';
import 'package:merge_dependencies/merge_dependencies.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        key: const Key('material_app'),
        title: 'Module',
        onGenerateTitle: (_) => 'Module',
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
        navigatorKey: rootNavigatorKey,
        onUnknownRoute: Merge.unknownRoute,
        onGenerateRoute: Merge.generateRoutes,
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
