import 'package:flutter/material.dart';
import 'package:merge_dependencies/merge_dependencies.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    key: const Key('materialApp'),
    onGenerateTitle: (_) => 'Module',
    debugShowCheckedModeBanner: false,

    /// theme style
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: context.options.themeMode,
    themeAnimationStyle: const AnimationStyle(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
      reverseCurve: Curves.easeInOut,
      reverseDuration: Duration(milliseconds: 300),
    ),

    /// route
    initialRoute: Routes.initial,
    navigatorKey: rootNavigatorKey,
    navigatorObservers: [navigatorObserver],
    onUnknownRoute: MergeDependencies.instance.unknownRoute,
    onGenerateRoute: MergeDependencies.instance.generateRoutes,

    /// text scale factor
    // builder: (context, child) => MediaQuery(
    //   data: MediaQuery.of(
    //     context,
    //   ).copyWith(textScaler: context.textScaler.clamp(minScaleFactor: 1, maxScaleFactor: 1.5)),
    //   child: child ?? Dimensions.kGap,
    // ),

    /// locale
    locale: context.options.locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
  );
}
