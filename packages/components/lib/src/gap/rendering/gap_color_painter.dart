import 'package:flutter/rendering.dart';

mixin GapColorPainter on RenderObject {
  Color? get color;

  void paintColor(PaintingContext context, Offset offset, Size size) {
    final Color? paintColor = color;
    if (paintColor != null) {
      context.canvas.drawRect(offset & size, Paint()..color = paintColor);
    }
  }
}
