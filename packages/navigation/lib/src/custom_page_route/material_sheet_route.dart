import 'package:flutter/material.dart';

class MaterialSheetPage<T> extends Page<T> {
  const MaterialSheetPage({
    required this.builder,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.enableDrag = true,
    this.useSafeArea = true,
    this.isScrollControlled = true,
  });

  final WidgetBuilder builder;
  final bool enableDrag;
  final bool useSafeArea;
  final bool isScrollControlled;

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    settings: this,
    builder: builder,
    enableDrag: enableDrag,
    useSafeArea: useSafeArea,
    isScrollControlled: isScrollControlled,
  );
}
