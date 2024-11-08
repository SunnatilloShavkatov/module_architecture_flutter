import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class RotateLoading extends StatelessWidget {
  const RotateLoading({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => RotateIcon(
        duration: const Duration(seconds: 1),
        child: child,
      );
}

/// Class use to render an animated icon with rotation
class RotateIcon extends StatefulWidget {
  const RotateIcon({required this.child, required this.duration, super.key});

  final Widget child;
  final Duration duration;

  @override
  State<RotateIcon> createState() => _RotateIconState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>("duration", duration));
  }
}

class _RotateIconState extends State<RotateIcon>
    with SingleTickerProviderStateMixin {
  /// Controller to animate the children
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        child: widget.child,
        builder: (_, Widget? widget) => Transform.rotate(
          angle: _animationController.value * 6.3,
          child: widget,
        ),
      );
}
