import 'dart:async';
import 'dart:math' as math;

import 'package:components/src/loading/nuts_activity_indicator.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

/// default loading
const Align defaultLoading = Align(child: CustomCircularProgressIndicator.adaptive());

/// A base class for the capped progress indicators.
abstract class _CircularProgressIndicator extends StatefulWidget {
  const new({
    super.key,
    this.value,
    this.backgroundColor = Colors.transparent,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.size = 28,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double size;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? color ?? ProgressIndicatorTheme.of(context).color ?? Theme.of(context).colorScheme.primary;

  Widget _buildSemanticsWrapper({required BuildContext context, required Widget child}) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(label: semanticsLabel, value: expandedSemanticsValue, child: child);
  }
}

class _CircularCappedProgressIndicatorPainter extends CustomPainter {
  new({
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
    required this.strokeCap,
    this.backgroundColor,
  }) : arcStart = value != null
           ? _startAngle
           : _startAngle + tailValue * 3 / 2 * math.pi + rotationValue * math.pi * 2.0 + offsetValue * 0.5 * math.pi,
       arcSweep = value != null
           ? clampDouble(value, 0, 1) * _sweep
           : math.max(headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi, _epsilon);

  final Color? backgroundColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double arcStart;
  final double arcSweep;
  final StrokeCap strokeCap;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;

  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap;
    if (backgroundColor != null) {
      final Paint backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = strokeCap;
      canvas.drawArc(Offset.zero & size, 0, _sweep, false, backgroundPaint);
    }

    if (value == null) {
      // Indeterminate
      paint.strokeCap = strokeCap;
    }

    canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_CircularCappedProgressIndicatorPainter oldPainter) =>
      oldPainter.backgroundColor != backgroundColor ||
      oldPainter.valueColor != valueColor ||
      oldPainter.value != value ||
      oldPainter.headValue != headValue ||
      oldPainter.tailValue != tailValue ||
      oldPainter.offsetValue != offsetValue ||
      oldPainter.rotationValue != rotationValue ||
      oldPainter.strokeWidth != strokeWidth;
}

/// Material circular progress indicator with a custom stroke cap; determinate when [value] is set, spinning when null.
class CustomCircularProgressIndicator extends _CircularProgressIndicator {
  /// Creates a circular progress indicator.
  const new({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.strokeWidth = 3.0,
    this.strokeCap = StrokeCap.round,
    this.activeColor,
    this.inactiveColor,
    super.semanticsLabel,
    super.semanticsValue,
    super.size = 28,
  }) : _indicatorType = _ActivityIndicatorType.material;

  /// Adaptive: [CupertinoActivityIndicator] on iOS, [CustomCircularProgressIndicator] elsewhere, which drops most args.
  const new adaptive({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    super.size = 28,
    this.strokeWidth = 3.0,
    this.strokeCap = StrokeCap.round,
    this.activeColor,
    this.inactiveColor,
    super.semanticsLabel,
    super.semanticsValue,
  }) : _indicatorType = _ActivityIndicatorType.adaptive;

  final _ActivityIndicatorType _indicatorType;

  /// Color of the circular track being filled by the circular indicator.
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  /// The shape of the line endings.
  final StrokeCap strokeCap;

  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<CustomCircularProgressIndicator> createState() => _CircularCappedProgressIndicatorState();
}

class _CircularCappedProgressIndicatorState extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(curve: const SawTooth(_pathCount)));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(curve: const SawTooth(_pathCount)));
  static final Animatable<double> _offsetTween = CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween = CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
    );
    if (widget.value == null) {
      _controller.repeat().ignore();
    }
  }

  @override
  void didUpdateWidget(CustomCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat().ignore();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMaterialIndicator(
    BuildContext context,
    double headValue,
    double tailValue,
    double offsetValue,
    double rotationValue,
  ) {
    final Color? trackColor = widget.backgroundColor ?? ProgressIndicatorTheme.of(context).circularTrackColor;

    return widget._buildSemanticsWrapper(
      context: context,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: widget.size, width: widget.size),
        child: CustomPaint(
          painter: _CircularCappedProgressIndicatorPainter(
            value: widget.value,
            headValue: headValue,
            tailValue: tailValue,
            offsetValue: offsetValue,
            backgroundColor: trackColor,
            strokeCap: widget.strokeCap,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
            valueColor: widget._getValueColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() => RepaintBoundary(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => _buildMaterialIndicator(
        context,
        _strokeHeadTween.evaluate(_controller),
        _strokeTailTween.evaluate(_controller),
        _offsetTween.evaluate(_controller),
        _rotationTween.evaluate(_controller),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    switch (widget._indicatorType) {
      case _ActivityIndicatorType.material:
        if (widget.value != null) {
          return _buildMaterialIndicator(context, 0, 0, 0, 0);
        }
        return _buildAnimation();
      case _ActivityIndicatorType.adaptive:
        final ThemeData theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return NutsActivityIndicator(
              key: widget.key,
              activeColor: widget.activeColor,
              inactiveColor: widget.inactiveColor,
            );
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            if (widget.value != null) {
              return _buildMaterialIndicator(context, 0, 0, 0, 0);
            }
            return _buildAnimation();
        }
    }
  }
}
