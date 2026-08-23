import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/src/custom_page_route/material_sheet_page.dart';

/// Bottom sheet route: the builder returns the sheet content, the route wraps it in a [MaterialSheetPage].
final class MaterialSheetRoute extends GoRoute {
  new({
    super.name,
    super.redirect,
    super.routes,
    required super.path,
    super.parentNavigatorKey,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    bool enableDrag = true,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? modalBarrierColor,
  }) : super(
         builder: builder,
         pageBuilder: (BuildContext context, GoRouterState state) => MaterialSheetPage<void>(
           key: state.pageKey,
           enableDrag: enableDrag,
           useSafeArea: useSafeArea,
           isDismissible: isDismissible,
           name: state.name ?? state.path,
           restorationId: state.pageKey.value,
           modalBarrierColor: modalBarrierColor,
           isScrollControlled: isScrollControlled,
           arguments: <String, String>{...state.pathParameters, ...state.uri.queryParameters},
           builder: (context) => builder(context, state),
         ),
       );
}
