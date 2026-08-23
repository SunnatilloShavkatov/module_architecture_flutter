import 'package:material_ui/material_ui.dart';

/// Cross-module widget hand-off: the owning module implements this and registers it under an
/// `InstanceNameKeys` key, the consuming module resolves it and calls [create] — without importing
/// the owning module's package or its widget class.
///
/// [T] is the widget's argument bundle, and it must be a type both modules can see, so it lives in
/// `packages/core/lib/src/entities/` — never the owning module's entity/model.
abstract interface class WidgetFactory<T> {
  const new();

  Widget create(T args);
}
