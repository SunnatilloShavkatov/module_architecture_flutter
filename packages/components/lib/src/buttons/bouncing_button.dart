import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  /// BouncingWidget constructor
  const BouncingButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.scaleFactor = 1,
    this.duration = const Duration(milliseconds: 300),
    this.stayOnBottom = false,
  });

  /// Child that will receive the bouncing animation
  final Widget child;

  /// Callback on click event
  final VoidCallback onPressed;

  /// Scale factor
  ///  < 0 => the bouncing will be reversed and widget will grow
  ///    1 => default value
  ///  > 1 => increase the bouncing effect
  final double scaleFactor;

  /// Animation duration
  final Duration duration;

  /// Whether the animation can revers or not
  final bool stayOnBottom;

  @override
  State<BouncingButton> createState() => _BouncingButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<Duration>('duration', duration))
      ..add(DoubleProperty('scaleFactor', scaleFactor))
      ..add(DiagnosticsProperty<bool>('stayOnBottom', stayOnBottom));
  }
}

class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  //// Animation controller
  late AnimationController _controller;

  /// View scale used in order to make the bouncing animation
  late double _scale;

  /// Key of the given child used to get its size and position whenever we need
  final GlobalKey _childKey = GlobalKey();

  /// If the touch position is outside or not of the given child
  bool _isOutside = false;

  /// Simple getter on widget's child
  Widget get child => widget.child;

  /// Simple getter on widget's onPressed callback
  VoidCallback get onPressed => widget.onPressed;

  /// Simple getter on widget's scaleFactor
  double get scaleFactor => widget.scaleFactor;

  /// Simple getter on widget's animation duration
  Duration get duration => widget.duration;

  /// Simple getter on widget's stayOnBottom boolean
  bool get _stayOnBottom => widget.stayOnBottom;

  /// We instantiate the animation controller
  /// The idea is to call setState() each time the controller's
  /// value changes
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: duration,
      upperBound: 0.1,
    )..addListener(
        () {
          setState(() {});
        },
      );
  }

  @override
  void didUpdateWidget(BouncingButton oldWidget) {
    if (oldWidget.stayOnBottom != _stayOnBottom) {
      if (!_stayOnBottom) {
        _reverseAnimation();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Dispose the animation controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Each time the [_controller]'s value changes, build() will be called
  /// We just have to calculate the appropriate scale from the controller value
  /// and pass it to our Transform.scale widget
  @override
  Widget build(BuildContext context) {
    _scale = 1 - (_controller.value * scaleFactor);
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onLongPressEnd: (LongPressEndDetails details) => _onLongPressEnd(details, context),
      onHorizontalDragEnd: _onDragEnd,
      onVerticalDragEnd: _onDragEnd,
      onHorizontalDragUpdate: (DragUpdateDetails details) => _onDragUpdate(details, context),
      onVerticalDragUpdate: (DragUpdateDetails details) => _onDragUpdate(details, context),
      child: Transform.scale(
        key: _childKey,
        scale: _scale,
        child: child,
      ),
    );
  }

  /// Simple method called when we need to notify the user of a press event
  void _triggerOnPressed() {
    onPressed();
  }

  /// We start the animation
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  /// We reverse the animation and notify the user of a press event
  void _onTapUp(TapUpDetails details) {
    if (!_stayOnBottom) {
      Future<void>.delayed(duration, _reverseAnimation);
    }

    _triggerOnPressed();
  }

  /// Here we are listening on each change when drag event is triggered
  /// We must keep the [_isOutside] value updated in order to use it later
  void _onDragUpdate(DragUpdateDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;
    _isOutside = _isOutsideChildBox(touchPosition);
  }

  /// When this callback is triggered, we reverse the animation
  /// If the touch position is inside the children renderBox, we notify the user
  /// of a press event
  void _onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;

    if (!_isOutsideChildBox(touchPosition)) {
      _triggerOnPressed();
    }

    _reverseAnimation();
  }

  /// When this callback is triggered, we reverse the animation
  /// As we do not have position details, we use the [_isOutside] field to know
  /// if we need to notify the user of a press event
  void _onDragEnd(DragEndDetails details) {
    if (!_isOutside) {
      _triggerOnPressed();
    }
    _reverseAnimation();
  }

  void _reverseAnimation() {
    if (mounted) {
      _controller.reverse();
    }
  }

  /// Method called when we need to now if a specific touch position is inside
  /// the given
  /// child render box
  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox? childRenderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (childRenderBox == null) {
      return true;
    }
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed))
      ..add(DoubleProperty('scaleFactor', scaleFactor))
      ..add(DiagnosticsProperty<Duration>('duration', duration));
  }
}
