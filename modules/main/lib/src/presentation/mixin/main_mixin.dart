part of "../main_page.dart";

mixin MainMixin on State<MainPage> {
  int _currentIndex = 0;
  final Set<int> _isTabLoaded = {0};

  void _onTabTapped(int index) {
    if (!_isTabLoaded.contains(index)) {
      _isTabLoaded.add(index);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
