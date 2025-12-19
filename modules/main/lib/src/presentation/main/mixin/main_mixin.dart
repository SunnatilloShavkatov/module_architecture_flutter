part of '../main_page.dart';

mixin MainMixin on State<MainPage> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  final Set<int> _isTabLoaded = {0};

  void _onTabTapped(int index) {
    if (!_isTabLoaded.contains(index)) {
      _isTabLoaded.add(index);
    }
    _currentIndexNotifier.value = index;
  }

  Injector get di => AppInjector.instance;

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }
}
