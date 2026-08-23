import 'package:components/src/gap/rendering/gap_color_painter.dart';
import 'package:flutter/rendering.dart';

class RenderSliverGap extends RenderSliver with GapColorPainter {
  new(this._mainAxisExtent, this._color);

  double get mainAxisExtent => _mainAxisExtent;
  double _mainAxisExtent;

  set mainAxisExtent(double value) {
    if (_mainAxisExtent != value) {
      _mainAxisExtent = value;
      markNeedsLayout();
    }
  }

  @override
  Color? get color => _color;
  Color? _color;

  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    final double paintExtent = calculatePaintOffset(constraints, from: 0, to: mainAxisExtent);
    final double cacheExtent = calculateCacheOffset(constraints, from: 0, to: mainAxisExtent);

    assert(paintExtent.isFinite, '');
    assert(paintExtent >= 0.0, '');
    geometry = SliverGeometry(
      scrollExtent: mainAxisExtent,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: mainAxisExtent,
      hitTestExtent: paintExtent,
      hasVisualOverflow: mainAxisExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Size size = constraints
        .asBoxConstraints(minExtent: geometry!.paintExtent, maxExtent: geometry!.paintExtent)
        .constrain(Size.zero);
    paintColor(context, offset, size);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('mainAxisExtent', mainAxisExtent));
  }
}
