import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:go_router/go_router.dart';

/// go_router detects the app type via `package:flutter/material`'s MaterialApp; this app uses `package:material_ui`, so
/// go_router's own page falls back to NoTransitionPage — this route restores a Cupertino page with the swipe-back gesture.
final class CupertinoRoute extends GoRoute {
  new({
    super.name,
    super.redirect,
    super.routes,
    required super.path,
    super.parentNavigatorKey,
    required Widget Function(BuildContext context, GoRouterState state) builder,
  }) : super(
         builder: builder,
         pageBuilder: (BuildContext context, GoRouterState state) => CupertinoPage<void>(
           key: state.pageKey,
           name: state.name ?? state.path,
           restorationId: state.pageKey.value,
           arguments: <String, String>{...state.pathParameters, ...state.uri.queryParameters},
           child: builder(context, state),
         ),
       );
}
