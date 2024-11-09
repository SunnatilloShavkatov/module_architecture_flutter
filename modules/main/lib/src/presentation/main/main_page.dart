import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:main/src/presentation/main/widget/custom_navigation_bar.dart";
import "package:main/src/presentation/main/widget/offstage_stack.dart";
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
        extendBody: true,
        body: ValueListenableBuilder(
          valueListenable: _currentIndexNotifier,
          builder: (_, int currentIndex, __) => IndexedStack(
            key: const Key("main_stack"),
            index: currentIndex,
            children: [
              OffstageStack(
                key: const Key("offstage_home"),
                isVisited: _isTabLoaded.contains(0),
                child: CustomScrollView(
                  slivers: [
                    SliverSafeArea(
                      minimum: Dimensions.kPaddingAll16,
                      sliver: SliverList.separated(
                        itemBuilder: (_, int index) => ListTile(
                          title: Text("$index"),
                        ),
                        separatorBuilder: (_, __) => Dimensions.kGap8,
                        itemCount: 100,
                      ),
                    ),
                  ],
                ),
              ),
              OffstageStack(
                key: const Key("offstage_settings"),
                isVisited: _isTabLoaded.contains(1),
                child: const PlaceholderScreen(text: "Settings Screen", key: Key("settings")),
              ),
              OffstageStack(
                key: const Key("offstage_profile"),
                isVisited: _isTabLoaded.contains(2),
                child: const PlaceholderScreen(text: "Profile Screen", key: Key("profile")),
              ),
              OffstageStack(
                key: const Key("offstage_more"),
                isVisited: _isTabLoaded.contains(3),
                child: const MorePage(key: Key("more")),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: Dimensions.kPaddingAll16,
          child: ValueListenableBuilder(
            valueListenable: _currentIndexNotifier,
            builder: (_, int currentIndex, __) => CustomNavigationBar(
              key: const Key("custom_navigation_bar"),
              currentIndex: currentIndex,
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
        ),
      );
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    logMessage("Building $text");
    return Center(child: Text(text));
  }
}
