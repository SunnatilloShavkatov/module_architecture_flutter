import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:home/src/presentation/main/home_page.dart';

final class HomePageFactory implements PageFactory {
  const HomePageFactory();

  @override
  Widget create(Injector di) => const HomePage();
}
