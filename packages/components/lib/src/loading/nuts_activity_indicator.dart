import 'dart:math' as math;

import 'package:components/src/extension/theme_extension.dart';
import 'package:flutter/widgets.dart';

class NutsActivityIndicator extends StatefulWidget {
  const new({
    super.key,
    this.animating = true,
    this.radius = 15,
    this.startRatio = 0.35,
    this.endRatio = 1.0,
    this.tickCount = 8,
    this.activeColor,
    this.inactiveColor,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.relativeWidth = 1.5,
  });

  /// Whether the activity indicator is running its animation. Defaults to true.
  final bool animating;

  /// Radius of the activity indicator. Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  /// The count of rectangles the activity indicator has.
  final int tickCount;

  /// The active color of the small rectangles within the activity indicator.
  final Color? activeColor;

  /// The de active color of the small rectangles within the activity indicator.
  final Color? inactiveColor;

  /// The time in which the activity indicator's animation finishes.
  final Duration animationDuration;

  final double relativeWidth;

  /// Radius ratio tells where the rectangles start.
  final double startRatio;

  /// Radius ratio tells where the rectangles end.
  final double endRatio;

  @override
  State<NutsActivityIndicator> createState() => _NutsActivityIndicatorState();
}

class _NutsActivityIndicatorState extends State<NutsActivityIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: widget.animationDuration, vsync: this);
    if (widget.animating) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(NutsActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.activeColor ?? context.color.primary;
    final Color inactiveColor = widget.inactiveColor ?? context.color.onBackground;
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _NutsActivityIndicatorPainter(
          animationController: _animationController,
          radius: widget.radius,
          tickCount: widget.tickCount,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          relativeWidth: widget.relativeWidth,
          endRatio: widget.endRatio,
          startRatio: widget.startRatio,
        ),
      ),
    );
  }
}

class _NutsActivityIndicatorPainter extends CustomPainter {
  new({
    required this.radius,
    required this.tickCount,
    required this.animationController,
    required this.activeColor,
    required this.inactiveColor,
    required this.relativeWidth,
    required this.startRatio,
    required this.endRatio,
  }) : _halfTickCount = tickCount ~/ 2,
       _tickRRect = RRect.fromLTRBXY(
         -radius * endRatio,
         relativeWidth * radius / 10,
         -radius * startRatio,
         -relativeWidth * radius / 10,
         radius,
         radius,
       ),
       super(repaint: animationController);
  final int _halfTickCount;
  final Animation<double> animationController;
  final Color activeColor;
  final Color inactiveColor;
  final double relativeWidth;
  final int tickCount;
  final double radius;
  final RRect _tickRRect;
  final double startRatio;
  final double endRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2);
    final activeTick = (tickCount * animationController.value).floor();
    for (int i = 0; i < tickCount; ++i) {
      paint.color = Color.lerp(activeColor, inactiveColor, ((i + activeTick) % tickCount) / _halfTickCount)!;
      canvas
        ..drawRRect(_tickRRect, paint)
        ..rotate(-math.pi * 2 / tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_NutsActivityIndicatorPainter oldPainter) => oldPainter.animationController != animationController;
}
