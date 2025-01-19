import 'package:chuck_interceptor/chuck.dart';
import 'package:flutter/material.dart';
import 'package:navigation/src/observer/route_navigation_observer.dart';

export 'src/name_routes.dart';
export 'src/observer/route_navigation_observer.dart';

final Chuck chuck = Chuck(navigatorKey: rootNavigatorKey);
final RouteNavigationObserver navigatorObserver = RouteNavigationObserver();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
