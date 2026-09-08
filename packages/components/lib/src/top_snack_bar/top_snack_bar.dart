import 'dart:async' show Timer;

import 'package:components/src/theme/themes.dart';
import 'package:components/src/universal/safe_area.dart';
import 'package:material_ui/material_ui.dart';

part 'custom_snack_bar.dart';

part 'safe_area_values.dart';

part 'tap_bounce_container.dart';

typedef ControllerCallback = void Function(AnimationController);

/// Represents possible triggers to dismiss the snackbar.
enum DismissType { onTap, onSwipe, none }

/// Represents possible vertical position of snackbar.
enum SnackBarPosition { top, bottom }

OverlayEntry? _previousEntry;
final Expando<bool> _removedOverlayEntries = Expando<bool>('removedTopSnackBarEntries');

bool _wasOverlayEntryRemoved(OverlayEntry entry) => _removedOverlayEntries[entry] ?? false;

void _removeOverlayEntryOnce(OverlayEntry entry) {
  if (_wasOverlayEntryRemoved(entry)) {
    return;
  }
  _removedOverlayEntries[entry] = true;
  entry.remove();
  if (identical(_previousEntry, entry)) {
    _previousEntry = null;
  }
}

/// The [overlayState] argument is used to add specific overlay state.
void showTopSnackBar(
  OverlayState overlayState,
  Widget child, {
  VoidCallback? onTap,
  bool persistent = false,
  Curve curve = Curves.elasticOut,
  Curve reverseCurve = Curves.linearToEaseOut,
  DismissType dismissType = DismissType.onTap,
  EdgeInsets padding = const EdgeInsets.all(16),
  ControllerCallback? onAnimationControllerInit,
  SafeAreaValues safeAreaValues = const SafeAreaValues(),
  SnackBarPosition snackBarPosition = SnackBarPosition.top,
  Duration displayDuration = const Duration(milliseconds: 3000),
  Duration animationDuration = const Duration(milliseconds: 2500),
  Duration reverseAnimationDuration = const Duration(milliseconds: 550),
  List<DismissDirection> dismissDirection = const [DismissDirection.up],
}) {
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (_) => _TopSnackBar(
      onDismissed: () {
        if (overlayEntry.mounted || !_wasOverlayEntryRemoved(overlayEntry)) {
          _removeOverlayEntryOnce(overlayEntry);
        }
      },
      onTap: onTap,
      curve: curve,
      padding: padding,
      persistent: persistent,
      dismissType: dismissType,
      reverseCurve: reverseCurve,
      safeAreaValues: safeAreaValues,
      displayDuration: displayDuration,
      snackBarPosition: snackBarPosition,
      dismissDirections: dismissDirection,
      animationDuration: animationDuration,
      reverseAnimationDuration: reverseAnimationDuration,
      onAnimationControllerInit: onAnimationControllerInit,
      child: child,
    ),
  );

  if (_previousEntry != null && _previousEntry!.mounted) {
    _removeOverlayEntryOnce(_previousEntry!);
  }

  overlayState.insert(overlayEntry);
  _previousEntry = overlayEntry;
}

/// Widget that controls all animations
class _TopSnackBar extends StatefulWidget {
  const new({
    required this.child,
    required this.onDismissed,
    required this.animationDuration,
    required this.reverseAnimationDuration,
    required this.displayDuration,
    required this.padding,
    required this.curve,
    required this.reverseCurve,
    required this.safeAreaValues,
    required this.dismissDirections,
    required this.snackBarPosition,
    this.onTap,
    this.persistent = false,
    this.onAnimationControllerInit,
    this.dismissType = DismissType.onTap,
  });

  final Widget child;
  final VoidCallback onDismissed;
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Duration displayDuration;
  final VoidCallback? onTap;
  final ControllerCallback? onAnimationControllerInit;
  final bool persistent;
  final EdgeInsets padding;
  final Curve curve;
  final Curve reverseCurve;
  final SafeAreaValues safeAreaValues;
  final DismissType dismissType;
  final List<DismissDirection> dismissDirections;
  final SnackBarPosition snackBarPosition;

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar> with SingleTickerProviderStateMixin {
  late final Animation<Offset> _offsetAnimation;
  late final AnimationController _animationController;

  Timer? _timer;

  late final Tween<Offset> _offsetTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.reverseAnimationDuration,
    );
    _animationController.addStatusListener(_statusListener);

    widget.onAnimationControllerInit?.call(_animationController);

    switch (widget.snackBarPosition) {
      case SnackBarPosition.top:
        _offsetTween = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero);
      case SnackBarPosition.bottom:
        _offsetTween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);
    }

    _offsetAnimation = _offsetTween.animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
    );
    if (mounted) {
      _animationController.forward().ignore();
    }
    super.initState();
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && !widget.persistent) {
      _timer = Timer(widget.displayDuration, () {
        if (mounted) {
          _animationController.reverse().ignore();
        }
      });
    }
    if (status == AnimationStatus.dismissed) {
      if (mounted) {
        _timer?.cancel();
        widget.onDismissed.call();
      }
    }
  }

  @override
  void dispose() {
    _animationController
      ..removeStatusListener(_statusListener)
      ..dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Positioned(
    top: widget.snackBarPosition == SnackBarPosition.top ? widget.padding.top : null,
    bottom: widget.snackBarPosition == SnackBarPosition.bottom ? widget.padding.bottom : null,
    left: widget.padding.left,
    right: widget.padding.right,
    child: SlideTransition(
      position: _offsetAnimation,
      child: SafeAreaWithMinimum(
        top: widget.safeAreaValues.top,
        bottom: widget.safeAreaValues.bottom,
        left: widget.safeAreaValues.left,
        right: widget.safeAreaValues.right,
        minimum: widget.safeAreaValues.minimum,
        child: _buildDismissibleChild(),
      ),
    ),
  );

  /// Build different type of [Widget] depending on [DismissType] value
  Widget _buildDismissibleChild() {
    switch (widget.dismissType) {
      case DismissType.onTap:
        return TapBounceContainer(
          onTap: () async {
            widget.onTap?.call();
            if (!widget.persistent && mounted) {
              await _animationController.reverse();
            }
          },
          child: widget.child,
        );
      case DismissType.onSwipe:
        Widget childWidget = widget.child;
        for (final DismissDirection direction in widget.dismissDirections) {
          childWidget = Dismissible(
            direction: direction,
            key: UniqueKey(),
            dismissThresholds: const <DismissDirection, double>{DismissDirection.up: 0.2},
            confirmDismiss: (DismissDirection direction) async {
              if (!widget.persistent && mounted) {
                if (direction == DismissDirection.down) {
                  await _animationController.reverse();
                } else {
                  _animationController.reset();
                }
              }
              return false;
            },
            child: childWidget,
          );
        }
        return childWidget;
      case DismissType.none:
        return widget.child;
    }
  }
}
