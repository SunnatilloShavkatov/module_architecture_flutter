import 'package:flutter/material.dart';

class MaterialSheetRoute<T> extends ModalBottomSheetRoute<T> {
  MaterialSheetRoute({
    super.settings,
    super.enableDrag,
    required super.builder,
    super.useSafeArea = true,
    super.isScrollControlled = true,
  });
}
