import 'package:core/src/core_abstractions/injector.dart';
import 'package:material_ui/material_ui.dart';

abstract interface class PageFactory {
  const new();

  Widget create(Injector di);
}
