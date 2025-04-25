import 'package:flutter/material.dart';

class CustomRectangleBorder extends OutlinedBorder {
  /// Creates a [CustomRectangleBorder].
  const CustomRectangleBorder({
    super.side,
    this.isTop = false,
    this.isBottom = false,
  });

  final bool isTop;
  final bool isBottom;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(
        top: isTop ? side.width : 0,
        bottom: isBottom ? side.width : 0,
      );

  @override
  ShapeBorder scale(double t) => CustomRectangleBorder(side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CustomRectangleBorder) {
      return CustomRectangleBorder(side: BorderSide.lerp(a.side, side, t));
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CustomRectangleBorder) {
      return CustomRectangleBorder(side: BorderSide.lerp(side, b.side, t));
    }
    return super.lerpTo(b, t);
  }

  ShapeBorder lerp(ShapeBorder? b, double t) {
    if (b is CustomRectangleBorder) {
      return CustomRectangleBorder(side: BorderSide.lerp(side, b.side, t));
    }
    return super.lerpTo(b, t)!;
  }

  Path _getPath(Rect rect) => Path()
    ..moveTo(rect.left, rect.top)
    ..lineTo(rect.right, rect.top)
    ..lineTo(rect.right, rect.bottom)
    ..lineTo(rect.left, rect.bottom)
    ..close();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _getPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _getPath(rect);

  @override
  CustomRectangleBorder copyWith({BorderSide? side}) =>
      CustomRectangleBorder(side: side ?? this.side);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) {
      return;
    }
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        Path? path;
        if (isBottom) {
          path = Path()
            ..moveTo(rect.left, rect.bottom)
            ..lineTo(rect.right, rect.bottom)
            ..close();
        } else if (isTop) {
          path = Path()
            ..moveTo(rect.left, rect.top)
            ..lineTo(rect.right, rect.top)
            ..close();
        }
        canvas.drawPath(
          path ?? _getPath(rect),
          side.toPaint(),
        );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomRectangleBorder &&
        other.side == side &&
        other.isTop == isTop &&
        other.isBottom == isBottom;
  }

  @override
  int get hashCode => side.hashCode ^ isTop.hashCode ^ isBottom.hashCode;

  @override
  String toString() =>
      '${(this, 'ContinuousRectangleBorder')}($side,$isTop,$isBottom)';
}
