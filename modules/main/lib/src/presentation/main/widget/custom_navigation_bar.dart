import "package:core/core.dart";
import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomNavigationBarItem> items;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  Widget build(BuildContext context) => Container(
        key: const Key("custom_navigation_bar_container"),
        height: 64,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Dimensions.kBorderRadius48,
          color: context.theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: const [BoxShadow(color: Colors.white, offset: Offset(0, 4))],
        ),
        child: Row(
          key: const Key("custom_navigation_bar"),
          children: List.generate(
            items.length.doubleTheListCount,
            (int index) => index.isEven
                ? _NavItem(
                    key: ValueKey<CustomNavigationBarItem>(items[index.exactIndex]),
                    item: items[index.exactIndex],
                    onTap: () => onTap(index.exactIndex),
                    isActive: currentIndex == index.exactIndex,
                    selectedLabelStyle: selectedLabelStyle,
                    unselectedLabelStyle: unselectedLabelStyle,
                  )
                : Dimensions.kGap8,
          ),
        ),
      );
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    super.key,
    this.onTap,
    required this.item,
    required this.isActive,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  final bool isActive;
  final VoidCallback? onTap;
  final CustomNavigationBarItem item;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _scaleAnimation = Tween<double>(begin: 0, end: 20).animate(_controller);
    _positionAnimation = Tween<double>(begin: 8, end: 0).animate(_controller);
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = context.theme.bottomNavigationBarTheme.selectedItemColor;
    final inactiveColor = context.theme.bottomNavigationBarTheme.unselectedItemColor;
    final unselectedLabelStyle =
        widget.unselectedLabelStyle ?? context.theme.bottomNavigationBarTheme.unselectedLabelStyle;
    final iconColor = widget.isActive ? activeColor : inactiveColor;
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        customBorder: const CircleBorder(),
        child: AnimatedBuilder(
          animation: _controller,
          child: IconTheme(
            key: const Key("icon"),
            data: IconThemeData(size: 24, color: iconColor),
            child: widget.item.icon,
          ),
          builder: (context, child) => Stack(
            key: const Key("stack"),
            alignment: Alignment.center,
            children: [
              Container(
                key: const Key("container"),
                width: 30 + _scaleAnimation.value,
                height: 30 + _scaleAnimation.value,
                decoration: BoxDecoration(
                  color: widget.isActive ? context.colorScheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              Align(
                key: const Key("icon_align"),
                child: Padding(
                  key: const Key("padding"),
                  padding: EdgeInsets.only(bottom: _positionAnimation.value),
                  child: child,
                ),
              ),
              Positioned(
                key: const Key("positioned"),
                left: 0,
                right: 0,
                bottom: 8,
                child: AnimatedSwitcher(
                  key: const Key("animated_switcher"),
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                    key: const Key("fade"),
                    opacity: animation,
                    child: SlideTransition(
                      key: const Key("slide"),
                      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(animation),
                      child: child,
                    ),
                  ),
                  child: widget.isActive
                      ? Dimensions.kGap
                      : Text(
                          key: const Key("label"),
                          widget.item.label,
                          style: unselectedLabelStyle?.copyWith(color: inactiveColor),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class CustomNavigationBarItem {
  const CustomNavigationBarItem({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomNavigationBarItem && other.icon == icon && other.label == label;
  }

  @override
  int get hashCode => Object.hash(icon, label);
}
