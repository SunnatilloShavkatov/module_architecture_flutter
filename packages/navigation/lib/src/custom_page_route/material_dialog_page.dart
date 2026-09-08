import 'package:material_ui/material_ui.dart';

/// Page-based dialog: the route lives in the router stack, so [Navigator.pop] cannot reach the wrong route.
class MaterialDialogPage<T> extends Page<T> {
  const new({
    required this.builder,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.barrierColor,
    this.useSafeArea = true,
    this.barrierDismissible = true,
  });

  final WidgetBuilder builder;
  final bool useSafeArea;
  final Color? barrierColor;
  final bool barrierDismissible;

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
    context: context,
    builder: builder,
    settings: this,
    useSafeArea: useSafeArea,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black54,
  );
}
