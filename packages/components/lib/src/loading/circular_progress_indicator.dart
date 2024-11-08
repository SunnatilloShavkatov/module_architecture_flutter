import "dart:math" as math;

import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

const double _kMinCircularProgressIndicatorSize = 36;
const int _kIndeterminateLinearDuration = 1800;
const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

/// A base class for the capped progress indicators.
abstract class _CircularProgressIndicator extends StatefulWidget {
  const _CircularProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ??
      color ??
      ProgressIndicatorTheme.of(context).color ??
      Theme.of(context).colorScheme.primary;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        PercentProperty(
          "value",
          value,
          showName: false,
          ifNull: "<indeterminate>",
        ),
      )
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("color", color))
      ..add(DiagnosticsProperty<Animation<Color?>?>("valueColor", valueColor))
      ..add(StringProperty("semanticsLabel", semanticsLabel))
      ..add(StringProperty("semanticsValue", semanticsValue));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= "${(value! * 100).round()}%";
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class _LinearCappedProgressIndicatorPainter extends CustomPainter {
  const _LinearCappedProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.animationValue,
    required this.textDirection,
    this.value,
    this.cornerRadius,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double? value;
  final double? cornerRadius;
  final double animationValue;
  final TextDirection textDirection;

  // The indeterminate progress animation displays two lines
  // whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0, 0.8, 1),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0, 1, 1),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0, 0, 0.65, 1),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0, 0.45, 1),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(cornerRadius ?? size.height / 2),
      ),
      paint,
    );

    paint.color = valueColor;

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
        case TextDirection.ltr:
          left = x;
      }
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset(left, 0) & Size(width, size.height),
          Radius.circular(cornerRadius ?? size.height / 2),
        ),
        paint,
      );
    }

    if (value != null) {
      drawBar(0, clampDouble(value!, 0, 1) * size.width);
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 =
          size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 =
          size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_LinearCappedProgressIndicatorPainter oldPainter) =>
      oldPainter.backgroundColor != backgroundColor ||
      oldPainter.valueColor != valueColor ||
      oldPainter.value != value ||
      oldPainter.animationValue != animationValue ||
      oldPainter.textDirection != textDirection;
}

class LinearCappedProgressIndicator extends _CircularProgressIndicator {
  /// Creates a linear progress indicator.
  const LinearCappedProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    this.cornerRadius,
    super.semanticsLabel,
    super.semanticsValue,
  }) : assert(
          minHeight == null || minHeight > 0,
          "minHeight must be null or positive",
        );

  /// Color of the track being filled by the linear indicator.
  ///
  /// If [LinearCappedProgressIndicator.backgroundColor] is null then the
  /// ambient [ProgressIndicatorThemeData.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.surface]
  /// will be used to draw the track.
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// The minimum height of the line used to draw the linear indicator.
  ///
  /// If [LinearCappedProgressIndicator.minHeight] is null then it will use the
  /// ambient [ProgressIndicatorThemeData.linearMinHeight]. If that is null
  /// it will use 4dp.
  final double? minHeight;

  /// The corner radii of the track and linear indicator.
  ///
  /// If null, it will use half of the indicator height as default
  /// (rounding off the corners completely).
  final double? cornerRadius;

  @override
  State<LinearCappedProgressIndicator> createState() =>
      _LinearCappedProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("minHeight", minHeight))
      ..add(DoubleProperty("cornerRadius", cornerRadius));
  }
}

class _LinearCappedProgressIndicatorState
    extends State<LinearCappedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LinearCappedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(
    BuildContext context,
    double animationValue,
    TextDirection textDirection,
  ) {
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        Theme.of(context).colorScheme.surface;
    final double minHeight =
        widget.minHeight ?? indicatorTheme.linearMinHeight ?? 4.0;

    return widget._buildSemanticsWrapper(
      context: context,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: minHeight,
        ),
        child: CustomPaint(
          painter: _LinearCappedProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget._getValueColor(context),
            value: widget.value,
            // may be null
            cornerRadius: widget.cornerRadius,
            animationValue: animationValue,
            // ignored if widget.value is not null
            textDirection: textDirection,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) =>
          _buildIndicator(context, _controller.value, textDirection),
    );
  }
}

class _CircularCappedProgressIndicatorPainter extends CustomPainter {
  _CircularCappedProgressIndicatorPainter({
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
    required this.strokeCap,
    this.backgroundColor,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 2.0 +
                offsetValue * 0.5 * math.pi,
        arcSweep = value != null
            ? clampDouble(value, 0, 1) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon,
              );

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

  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
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

/// A Material Design circular progress indicator with a custom stroke cap,
/// which spins to indicate that
/// the application is busy.
///
/// A widget that shows progress along a circle. There are two kinds of circular
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator arc is displayed with [valueColor], an animated value. To
/// specify a constant color use: `AlwaysStoppedAnimation<Color>(color)`.
class CustomCircularProgressIndicator extends _CircularProgressIndicator {
  /// Creates a circular progress indicator.
  const CustomCircularProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.strokeWidth = 3.0,
    this.strokeCap = StrokeCap.round,
    super.semanticsLabel,
    super.semanticsValue,
  }) : _indicatorType = _ActivityIndicatorType.material;

  /// Creates an adaptive progress indicator that is a
  /// [CupertinoActivityIndicator] in iOS and
  /// [CustomCircularProgressIndicator] in
  /// material theme/non-iOS.
  ///
  /// The [value], [backgroundColor], [valueColor], [strokeWidth],
  /// [semanticsLabel], and [semanticsValue] will be ignored in iOS.
  ///
  const CustomCircularProgressIndicator.adaptive({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    this.strokeWidth = 3.0,
    this.strokeCap = StrokeCap.round,
    super.semanticsLabel,
    super.semanticsValue,
  }) : _indicatorType = _ActivityIndicatorType.adaptive;

  final _ActivityIndicatorType _indicatorType;

  /// Color of the circular track being filled by the circular indicator.
  ///
  /// If [CustomCircularProgressIndicator.backgroundColor] is null then the
  /// ambient [ProgressIndicatorThemeData.circularTrackColor] will be used.
  /// If that is null, then the track will not be painted.
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  /// The shape of the line endings.
  final StrokeCap strokeCap;

  @override
  State<CustomCircularProgressIndicator> createState() =>
      _CircularCappedProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("strokeWidth", strokeWidth))
      ..add(EnumProperty<StrokeCap>("strokeCap", strokeCap));
  }
}

class _CircularCappedProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(
    CurveTween(
      curve: const SawTooth(_pathCount),
    ),
  );
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1, curve: Curves.fastOutSlowIn),
  ).chain(
    CurveTween(
      curve: const SawTooth(_pathCount),
    ),
  );
  static final Animatable<double> _offsetTween =
      CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween =
      CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CustomCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCupertinoIndicator(BuildContext context) {
    final Color? tickColor = widget.backgroundColor;
    return CupertinoActivityIndicator(key: widget.key, color: tickColor);
  }

  Widget _buildMaterialIndicator(
    BuildContext context,
    double headValue,
    double tailValue,
    double offsetValue,
    double rotationValue,
  ) {
    final Color? trackColor = widget.backgroundColor ??
        ProgressIndicatorTheme.of(context).circularTrackColor;

    return widget._buildSemanticsWrapper(
      context: context,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: _kMinCircularProgressIndicatorSize,
          minHeight: _kMinCircularProgressIndicatorSize,
        ),
        child: CustomPaint(
          painter: _CircularCappedProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget._getValueColor(context),
            value: widget.value,
            // may be null
            headValue: headValue,
            // remaining arguments are ignored if widget.value is not null
            tailValue: tailValue,
            offsetValue: offsetValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
            strokeCap: widget.strokeCap,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) =>
            _buildMaterialIndicator(
          context,
          _strokeHeadTween.evaluate(_controller),
          _strokeTailTween.evaluate(_controller),
          _offsetTween.evaluate(_controller),
          _rotationTween.evaluate(_controller),
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
            return _buildCupertinoIndicator(context);
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
