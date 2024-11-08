import "package:core/core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:main/src/presentation/widget/custom_navigation_bar.dart";
import "package:main/src/presentation/widget/offstage_stack.dart";
import "package:more/more.dart";

part "mixin/main_mixin.dart";

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
        key: const Key("main"),
        body: IndexedStack(
          key: const Key("main_stack"),
          index: _currentIndex,
          children: [
            OffstageStack(
              key: const Key("offstage_home"),
              isVisited: _isTabLoaded.contains(0),
              child: const PlaceholderScreen(key: PageStorageKey("home"), text: "Home"),
            ),
            OffstageStack(
              key: const Key("offstage_settings"),
              isVisited: _isTabLoaded.contains(1),
              child: const PlaceholderScreen(text: "Settings Screen", key: PageStorageKey("settings")),
            ),
            OffstageStack(
              key: const Key("offstage_profile"),
              isVisited: _isTabLoaded.contains(2),
              child: const PlaceholderScreen(text: "Profile Screen", key: PageStorageKey("profile")),
            ),
            OffstageStack(
              key: const Key("offstage_more"),
              isVisited: _isTabLoaded.contains(3),
              child: const MorePage(key: PageStorageKey("more")),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: Dimensions.kPaddingAll16,
          child: CustomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: [
              CustomNavigationBarItem(
                label: context.localizations.home,
                icon: const Icon(AppIcons.home),
              ),
              CustomNavigationBarItem(
                label: context.localizations.units,
                icon: const Icon(AppIcons.routing),
              ),
              CustomNavigationBarItem(
                label: context.localizations.resources,
                icon: const Icon(AppIcons.book_saved),
              ),
              CustomNavigationBarItem(
                label: context.localizations.more,
                icon: const Icon(AppIcons.more),
              ),
            ],
          ),
        ),
      );
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Building $text");
    }
    return Center(child: Text(text));
  }
}
