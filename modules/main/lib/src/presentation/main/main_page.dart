import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

part 'mixin/main_mixin.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    key: const Key('main'),
    extendBody: true,
    body: widget.navigationShell,
    bottomNavigationBar: BottomNavigationBar(
      onTap: _onTabTapped,
      currentIndex: widget.navigationShell.currentIndex,
      items: [
        BottomNavigationBarItem(label: context.localizations.home, icon: const Icon(Icons.home)),
        const BottomNavigationBarItem(label: 'Route', icon: Icon(Icons.route)),
        BottomNavigationBarItem(label: context.localizations.resources, icon: const Icon(Icons.book_rounded)),
        const BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person_rounded)),
      ],
    ),
  );
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    logMessage('Building $text');
    return Center(child: Text(text));
  }
}
