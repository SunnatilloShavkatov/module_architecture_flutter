import 'package:core/src/core_abstractions/injector.dart';
import 'package:flutter/material.dart';

abstract interface class PageFactory {
  const PageFactory();

  Widget create(Injector di);
}
