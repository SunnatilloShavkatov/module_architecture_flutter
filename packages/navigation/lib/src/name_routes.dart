part of "router.dart";

sealed class Routes {
  const Routes._();

  /// others
  static const String splash = "/";
  static const String noInternet = "/no-internet";
  static const String notFound = "/not-found";

  /// main
  static const String main = "/main";

  /// more
  static const String settings = "/settings";
}

sealed class RouteKeys {
  const RouteKeys._();

  static const String navigatorKey = "navigator_key";
  static const String navigatorObserver = "navigator_observer";
}
