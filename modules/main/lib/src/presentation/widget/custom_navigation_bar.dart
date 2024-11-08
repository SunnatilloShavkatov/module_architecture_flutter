import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:vector_math/vector_math_64.dart" as vector;

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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(64)),
          boxShadow: [BoxShadow(color: Colors.white, offset: Offset(0, 4))],
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
    required this.item,
    this.onTap,
    required this.isActive,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  final CustomNavigationBarItem item;
  final VoidCallback? onTap;
  final bool isActive;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final AnimationController _iconPositionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  late final Animation<double> _circleScaleAnimation;
  late final Animation<double> _iconPositionAnimation;

  @override
  void initState() {
    super.initState();
    _circleScaleAnimation = Tween<double>(begin: 0, end: 20).animate(_controller);
    _iconPositionAnimation = Tween<double>(begin: 8, end: 0).animate(_iconPositionController);
    if (widget.isActive) {
      _controller.forward();
      _iconPositionController.forward();
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      _controller.forward();
      _iconPositionController.forward();
    } else {
      _controller.reverse();
      _iconPositionController.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconPositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? selectedLabelStyle =
        widget.selectedLabelStyle ?? context.theme.bottomNavigationBarTheme.selectedLabelStyle;
    final TextStyle? unselectedLabelStyle =
        widget.unselectedLabelStyle ?? context.theme.bottomNavigationBarTheme.unselectedLabelStyle;
    final Color? iconColor = widget.isActive
        ? context.theme.bottomNavigationBarTheme.selectedItemColor
        : context.theme.bottomNavigationBarTheme.unselectedItemColor;
    final TextStyle? mergedLabelStyle = TextStyle.lerp(
      unselectedLabelStyle,
      selectedLabelStyle,
      _controller.value,
    )?.copyWith(color: iconColor);
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        customBorder: const CircleBorder(),
        child: Tooltip(
          preferBelow: false,
          excludeFromSemantics: true,
          message: widget.item.label,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Container(
                  width: 30 + _circleScaleAnimation.value,
                  height: 30 + _circleScaleAnimation.value,
                  decoration: BoxDecoration(
                    color: widget.isActive ? context.colorScheme.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Align(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Padding(
                    padding: EdgeInsets.only(bottom: _iconPositionAnimation.value),
                    child: IconTheme(
                      data: IconThemeData(size: 24, color: iconColor),
                      child: widget.item.icon,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(animation),
                      child: child,
                    ),
                  ),
                  child: widget.isActive ? const SizedBox.shrink() : Text(widget.item.label, style: mergedLabelStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.colorTween,
    required this.animation,
    required this.label,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
  });

  final ColorTween colorTween;
  final Animation<double> animation;
  final String label;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  Widget build(BuildContext context) {
    final double? selectedFontSize = selectedLabelStyle?.fontSize;
    final double? unselectedFontSize = unselectedLabelStyle?.fontSize;

    final TextStyle customStyle = TextStyle.lerp(
      unselectedLabelStyle,
      selectedLabelStyle,
      animation.value,
    )!;
    final Widget text = DefaultTextStyle.merge(
      style: customStyle.copyWith(
        fontSize: selectedFontSize,
        color: colorTween.evaluate(animation),
      ),
      // The font size should grow here when active, but because of the way
      // font rendering works, it doesn't grow smoothly if we just animate
      // the font size, so we use a transform instead.
      child: Transform(
        transform: Matrix4.diagonal3(
          vector.Vector3.all(
            Tween<double>(
              begin: unselectedFontSize! / selectedFontSize!,
              end: 1,
            ).evaluate(animation),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Text(label),
      ),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1,
      child: text,
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
