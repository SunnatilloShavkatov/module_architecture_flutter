import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/widgets.dart";

enum GestureType {
  onTapDown,
  onTapUp,
  onTap,
  onTapCancel,
  onSecondaryTapDown,
  onSecondaryTapUp,
  onSecondaryTapCancel,
  onDoubleTap,
  onLongPress,
  onLongPressStart,
  onLongPressMoveUpdate,
  onLongPressUp,
  onLongPressEnd,
  onVerticalDragDown,
  onVerticalDragStart,
  onVerticalDragUpdate,
  onVerticalDragEnd,
  onVerticalDragCancel,
  onHorizontalDragDown,
  onHorizontalDragStart,
  onHorizontalDragUpdate,
  onHorizontalDragEnd,
  onHorizontalDragCancel,
  onForcePressStart,
  onForcePressPeak,
  onForcePressUpdate,
  onForcePressEnd,
  onPanDown,
  onPanStart,
  onPanUpdateAnyDirection,
  onPanUpdateDownDirection,
  onPanUpdateUpDirection,
  onPanUpdateLeftDirection,
  onPanUpdateRightDirection,
  onPanEnd,
  onPanCancel,
  onScaleStart,
  onScaleUpdate,
  onScaleEnd,
}

class KeyboardDismiss extends StatelessWidget {
  const KeyboardDismiss({
    super.key,
    this.child,
    this.behavior,
    this.gestures = const <GestureType>[GestureType.onTap],
    this.dragStartBehavior = DragStartBehavior.start,
    this.excludeFromSemantics = false,
  });

  final List<GestureType> gestures;
  final DragStartBehavior dragStartBehavior;
  final HitTestBehavior? behavior;
  final bool excludeFromSemantics;
  final Widget? child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: behavior,
        dragStartBehavior: dragStartBehavior,
        excludeFromSemantics: excludeFromSemantics,
        onTap: gestures.contains(GestureType.onTap) ? () => _unFocus(context) : null,
        onTapDown: gestures.contains(GestureType.onTapDown) ? (_) => _unFocus(context) : null,
        onPanUpdate: gestures.contains(GestureType.onPanUpdateAnyDirection) ? (_) => _unFocus(context) : null,
        onTapUp: gestures.contains(GestureType.onTapUp) ? (_) => _unFocus(context) : null,
        onTapCancel: gestures.contains(GestureType.onTapCancel) ? () => _unFocus(context) : null,
        onSecondaryTapDown: gestures.contains(GestureType.onSecondaryTapDown) ? (_) => _unFocus(context) : null,
        onSecondaryTapUp: gestures.contains(GestureType.onSecondaryTapUp) ? (_) => _unFocus(context) : null,
        onSecondaryTapCancel: gestures.contains(GestureType.onSecondaryTapCancel) ? () => _unFocus(context) : null,
        onDoubleTap: gestures.contains(GestureType.onDoubleTap) ? () => _unFocus(context) : null,
        onLongPress: gestures.contains(GestureType.onLongPress) ? () => _unFocus(context) : null,
        onLongPressStart: gestures.contains(GestureType.onLongPressStart) ? (_) => _unFocus(context) : null,
        onLongPressMoveUpdate: gestures.contains(GestureType.onLongPressMoveUpdate) ? (_) => _unFocus(context) : null,
        onLongPressUp: gestures.contains(GestureType.onLongPressUp) ? () => _unFocus(context) : null,
        onLongPressEnd: gestures.contains(GestureType.onLongPressEnd) ? (_) => _unFocus(context) : null,
        onVerticalDragDown: gestures.contains(GestureType.onVerticalDragDown) ? (_) => _unFocus(context) : null,
        onVerticalDragStart: gestures.contains(GestureType.onVerticalDragStart) ? (_) => _unFocus(context) : null,
        onVerticalDragUpdate: _gesturesContainsDirectionalPanUpdate()
            ? (DragUpdateDetails details) => _unFocusWithDetails(context, details)
            : null,
        onVerticalDragEnd: gestures.contains(GestureType.onVerticalDragEnd) ? (_) => _unFocus(context) : null,
        onVerticalDragCancel: gestures.contains(GestureType.onVerticalDragCancel) ? () => _unFocus(context) : null,
        onHorizontalDragDown: gestures.contains(GestureType.onHorizontalDragDown) ? (_) => _unFocus(context) : null,
        onHorizontalDragStart: gestures.contains(GestureType.onHorizontalDragStart) ? (_) => _unFocus(context) : null,
        onHorizontalDragUpdate: _gesturesContainsDirectionalPanUpdate()
            ? (DragUpdateDetails details) => _unFocusWithDetails(context, details)
            : null,
        onHorizontalDragEnd: gestures.contains(GestureType.onHorizontalDragEnd) ? (_) => _unFocus(context) : null,
        onHorizontalDragCancel: gestures.contains(GestureType.onHorizontalDragCancel) ? () => _unFocus(context) : null,
        onForcePressStart: gestures.contains(GestureType.onForcePressStart) ? (_) => _unFocus(context) : null,
        onForcePressPeak: gestures.contains(GestureType.onForcePressPeak) ? (_) => _unFocus(context) : null,
        onForcePressUpdate: gestures.contains(GestureType.onForcePressUpdate) ? (_) => _unFocus(context) : null,
        onForcePressEnd: gestures.contains(GestureType.onForcePressEnd) ? (_) => _unFocus(context) : null,
        onPanDown: gestures.contains(GestureType.onPanDown) ? (_) => _unFocus(context) : null,
        onPanStart: gestures.contains(GestureType.onPanStart) ? (_) => _unFocus(context) : null,
        onPanEnd: gestures.contains(GestureType.onPanEnd) ? (_) => _unFocus(context) : null,
        onPanCancel: gestures.contains(GestureType.onPanCancel) ? () => _unFocus(context) : null,
        onScaleStart: gestures.contains(GestureType.onScaleStart) ? (_) => _unFocus(context) : null,
        onScaleUpdate: gestures.contains(GestureType.onScaleUpdate) ? (_) => _unFocus(context) : null,
        onScaleEnd: gestures.contains(GestureType.onScaleEnd) ? (_) => _unFocus(context) : null,
        child: child,
      );

  void _unFocus(BuildContext context) => FocusScope.of(context).unfocus();

  void _unFocusWithDetails(BuildContext context, DragUpdateDetails details) {
    final double dy = details.delta.dy;
    final double dx = details.delta.dx;
    final bool isDragMainlyHorizontal = dx.abs() - dy.abs() > 0;
    if (gestures.contains(GestureType.onPanUpdateDownDirection) && dy > 0 && !isDragMainlyHorizontal) {
      _unFocus(context);
    } else if (gestures.contains(GestureType.onPanUpdateUpDirection) && dy < 0 && !isDragMainlyHorizontal) {
      _unFocus(context);
    } else if (gestures.contains(GestureType.onPanUpdateRightDirection) && dx > 0 && isDragMainlyHorizontal) {
      _unFocus(context);
    } else if (gestures.contains(GestureType.onPanUpdateLeftDirection) && dx < 0 && isDragMainlyHorizontal) {
      _unFocus(context);
    }
  }

  bool _gesturesContainsDirectionalPanUpdate() =>
      gestures.contains(GestureType.onPanUpdateDownDirection) ||
      gestures.contains(GestureType.onPanUpdateUpDirection) ||
      gestures.contains(GestureType.onPanUpdateRightDirection) ||
      gestures.contains(GestureType.onPanUpdateLeftDirection);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<GestureType>("gestures", gestures))
      ..add(EnumProperty<DragStartBehavior>("dragStartBehavior", dragStartBehavior))
      ..add(EnumProperty<HitTestBehavior?>("behavior", behavior))
      ..add(DiagnosticsProperty<bool>("excludeFromSemantics", excludeFromSemantics));
  }
}
