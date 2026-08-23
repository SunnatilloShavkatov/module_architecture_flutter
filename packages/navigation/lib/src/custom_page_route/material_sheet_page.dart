import 'package:material_ui/material_ui.dart';

class MaterialSheetPage<T> extends Page<T> {
  const new({
    required this.builder,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.modalBarrierColor,
    this.enableDrag = true,
    this.useSafeArea = true,
    this.isDismissible = true,
    this.isScrollControlled = true,
  });

  final WidgetBuilder builder;
  final bool enableDrag;
  final bool isDismissible;
  final bool useSafeArea;
  final bool isScrollControlled;
  final Color? modalBarrierColor;

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    settings: this,
    builder: builder,
    enableDrag: enableDrag,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    modalBarrierColor: modalBarrierColor,
    isScrollControlled: isScrollControlled,
    sheetAnimationStyle: const AnimationStyle(
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    ),
  );
}
