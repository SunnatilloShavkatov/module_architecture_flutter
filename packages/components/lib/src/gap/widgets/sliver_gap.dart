import 'package:components/src/gap/rendering/sliver_gap.dart';
import 'package:components/src/gap/widgets/gap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A sliver that takes a fixed amount of space.
///
/// See also:
///
///  * [Gap], the render box version of this widget.
class SliverGap extends LeafRenderObjectWidget {
  /// Creates a sliver that takes a fixed [mainAxisExtent] of space.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  const SliverGap(this.mainAxisExtent, {super.key, this.color})
    : assert(mainAxisExtent >= 0 && mainAxisExtent < double.infinity, '');

  /// The amount of space this widget takes in the direction of the parent.
  ///
  /// Must not be null and must be positive.
  final double mainAxisExtent;

  /// The color used to fill the gap.
  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverGap(mainAxisExtent: mainAxisExtent, color: color);

  @override
  void updateRenderObject(BuildContext context, RenderSliverGap renderObject) {
    renderObject
      ..mainAxisExtent = mainAxisExtent
      ..color = color;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('mainAxisExtent', mainAxisExtent));
  }
}
