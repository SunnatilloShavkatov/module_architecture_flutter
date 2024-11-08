import "package:flutter/material.dart";

class TabBarIndicator extends Decoration {
  TabBarIndicator({
    required Color color,
    required double radius,
  }) : _painter = _TabBarIndicator(color, radius);
  final BoxPainter _painter;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _TabBarIndicator extends BoxPainter {
  _TabBarIndicator(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;
  final Paint _paint;
  final double radius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset customOffset = offset +
        Offset(
          configuration.size!.width / 2,
          configuration.size!.height - radius - 3,
        );

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: customOffset,
          width: configuration.size!.width,
          height: 3,
        ),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      _paint,
    );
  }
}
