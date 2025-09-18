import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:navigation/src/observer/route_navigation_observer.dart';

export 'src/custom_page_route/fade_page_route.dart';
export 'src/custom_page_route/material_sheet_route.dart';
export 'src/name_routes.dart';
export 'src/observer/route_navigation_observer.dart';

final Chuck chuck = Chuck(navigatorKey: rootNavigatorKey);
final RouteNavigationObserver navigatorObserver = RouteNavigationObserver();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
