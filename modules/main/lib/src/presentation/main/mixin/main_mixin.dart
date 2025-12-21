part of '../main_page.dart';

mixin MainMixin on State<MainPage> {
  void _onTabTapped(int index) {
    if (index == widget.navigationShell.currentIndex) {
      return;
    }
    widget.navigationShell.goBranch(index);
  }

  Injector get di => AppInjector.instance;
}
