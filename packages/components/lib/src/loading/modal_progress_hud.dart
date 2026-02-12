import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ModalProgressHUD extends StatelessWidget {
  const ModalProgressHUD({
    required this.child,
    super.key,
    this.opacity = 0.3,
    this.inAsyncCall = false,
    this.dismissible = false,
    this.color = Colors.transparent,
    this.progressIndicator = const CircularProgressIndicator.adaptive(),
  });

  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final bool dismissible;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      child,
      Offstage(
        offstage: !inAsyncCall,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 100),
          child: ModalBarrier(dismissible: dismissible, color: color),
        ),
      ),
      Offstage(
        offstage: !inAsyncCall,
        child: Center(child: progressIndicator),
      ),
    ],
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('inAsyncCall', inAsyncCall))
      ..add(DoubleProperty('opacity', opacity))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<bool>('dismissible', dismissible));
  }
}
