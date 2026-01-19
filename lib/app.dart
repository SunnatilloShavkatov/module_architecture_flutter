import 'package:flutter/material.dart';
import 'package:merge_dependencies/merge_dependencies.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    key: const Key('materialApp'),
    onGenerateTitle: (_) => 'Module',
    debugShowCheckedModeBanner: false,

    /// theme style
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: context.options.themeMode,

    /// route
    routerConfig: MergeDependencies.router,

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
