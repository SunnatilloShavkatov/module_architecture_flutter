import 'package:chuck_interceptor/chuck.dart';
import 'package:flutter/material.dart';
import 'package:navigation/src/observer/route_navigation_observer.dart';

export 'package:smooth_sheets/smooth_sheets.dart';

export 'src/custom_page_route/fade_page_route.dart';
export 'src/custom_page_route/material_sheet_route.dart';
export 'src/custom_page_route/modal_bottom_sheet_route.dart';
export 'src/name_routes.dart';
export 'src/observer/route_navigation_observer.dart';

final Chuck chuck = Chuck(navigatorKey: rootNavigatorKey);
final RouteNavigationObserver navigatorObserver = RouteNavigationObserver();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
