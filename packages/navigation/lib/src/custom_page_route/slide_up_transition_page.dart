import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class SlideUpTransitionPage<T> extends CustomTransitionPage<T> {
  new({super.key, super.name, super.arguments, super.restorationId, required super.child})
    : super(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (_, animation, _, child) => _SlideUpTransition(animation: animation, child: child),
      );
}

// Flutter calls transitionsBuilder on every frame, and every CurvedAnimation registers a status listener on its parent
// that only dispose() removes — so the animation objects are built once here instead of per frame.
class _SlideUpTransition extends StatefulWidget {
  const new({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  State<_SlideUpTransition> createState() => _SlideUpTransitionState();
}

class _SlideUpTransitionState extends State<_SlideUpTransition> {
  static final Tween<Offset> _offsetUpTween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);

  late CurvedAnimation _curved;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  void didUpdateWidget(covariant _SlideUpTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) {
      _curved.dispose();
      _bind();
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  void _bind() {
    _curved = CurvedAnimation(parent: widget.animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
    _position = _offsetUpTween.animate(_curved);
  }

  @override
  Widget build(BuildContext context) => SlideTransition(position: _position, child: widget.child);
}
