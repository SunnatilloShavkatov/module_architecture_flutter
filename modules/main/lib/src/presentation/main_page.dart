import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:main/src/presentation/widget/custom_navigation_bar.dart";

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final Set<int> _isTabLoaded = {0};

  @override
  Widget build(BuildContext context) => Scaffold(
        body: const Center(child: Text("Main")),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: CustomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              if (!_isTabLoaded.contains(index)) {
                _isTabLoaded.add(index);
              }
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              CustomNavigationBarItem(icon: Icon(AppIcons.home), label: "Home"),
              CustomNavigationBarItem(icon: Icon(AppIcons.routing), label: "Units"),
              CustomNavigationBarItem(icon: Icon(AppIcons.book_saved), label: "Resources"),
              CustomNavigationBarItem(icon: Icon(AppIcons.more), label: "More"),
            ],
          ),
        ),
      );
}

