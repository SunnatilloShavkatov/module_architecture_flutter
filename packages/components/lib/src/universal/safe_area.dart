import 'dart:math' show max;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A sliver widget that provides safe area padding with customizable minimum padding
class SliverSafeAreaWithMinimum extends StatelessWidget {
  /// Creates a sliver that avoids operating system interfaces with minimum padding.
  const SliverSafeAreaWithMinimum({
    super.key,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    required this.sliver,
  });

  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum padding and the media padding will be applied.
  final EdgeInsets minimum;

  /// The sliver below this sliver in the tree.
  ///
  /// The padding on the [MediaQuery] for the [sliver] will be suitably adjusted
  /// to zero out any sides that were avoided by this sliver.
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckHasMediaQuery(context),
      'SliverSafeAreaWithMinimum must be placed inside a MaterialApp or WidgetsApp widget.',
    );
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    final calculatedPadding = EdgeInsets.only(
      left: _calculatePadding(left, padding.left, minimum.left),
      top: _calculatePadding(top, padding.top, minimum.top),
      right: _calculatePadding(right, padding.right, minimum.right),
      bottom: _calculatePadding(bottom, padding.bottom, minimum.bottom),
    );
    return SliverPadding(
      padding: calculatedPadding,
      sliver: MediaQuery.removePadding(
        context: context,
        removeLeft: left,
        removeTop: top,
        removeRight: right,
        removeBottom: bottom,
        child: sliver,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('top', value: top, ifTrue: 'avoid top padding'))
      ..add(FlagProperty('left', value: left, ifTrue: 'avoid left padding'))
      ..add(FlagProperty('right', value: right, ifTrue: 'avoid right padding'))
      ..add(FlagProperty('bottom', value: bottom, ifTrue: 'avoid bottom padding'))
      ..add(DiagnosticsProperty<EdgeInsets>('minimum', minimum));
  }
}

/// A widget that provides safe area padding with customizable minimum padding
class SafeAreaWithMinimum extends StatelessWidget {
  /// Creates a widget that avoids operating system interfaces with minimum padding.
  const SafeAreaWithMinimum({
    super.key,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewInsets = false,
    required this.child,
  });

  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum padding and the media padding will be applied.
  final EdgeInsets minimum;

  /// Specifies whether the [SafeAreaWithMinimum] should maintain the bottom
  /// [MediaQueryData.viewInsets] instead of the bottom [MediaQueryData.padding],
  /// defaults to false.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// SafeArea, the padding can be maintained below the obstruction rather than
  /// being consumed. This can be helpful in cases where your layout contains
  /// flexible widgets, which could visibly move when opening a software
  /// keyboard due to the change in the padding value. Setting this to true will
  /// avoid the UI shift.
  final bool maintainBottomViewInsets;

  /// The widget below this widget in the tree.
  ///
  /// The padding on the [MediaQuery] for the [child] will be suitably adjusted
  /// to zero out any sides that were avoided by this widget.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckHasMediaQuery(context),
      'SafeAreaWithMinimum must be placed inside a MaterialApp or WidgetsApp widget.',
    );
    EdgeInsets padding = MediaQuery.paddingOf(context);
    if (maintainBottomViewInsets) {
      padding = padding.copyWith(bottom: max(padding.bottom, MediaQuery.viewInsetsOf(context).bottom));
    }
    final calculatedPadding = EdgeInsets.only(
      left: _calculatePadding(left, padding.left, minimum.left),
      top: _calculatePadding(top, padding.top, minimum.top),
      right: _calculatePadding(right, padding.right, minimum.right),
      bottom: _calculatePadding(bottom, padding.bottom, minimum.bottom),
    );
    return Padding(
      padding: calculatedPadding,
      child: MediaQuery.removePadding(
        context: context,
        removeLeft: left,
        removeTop: top,
        removeRight: right,
        removeBottom: bottom,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('top', value: top, ifTrue: 'avoid top padding'))
      ..add(FlagProperty('left', value: left, ifTrue: 'avoid left padding'))
      ..add(FlagProperty('right', value: right, ifTrue: 'avoid right padding'))
      ..add(FlagProperty('bottom', value: bottom, ifTrue: 'avoid bottom padding'))
      ..add(DiagnosticsProperty<EdgeInsets>('minimum', minimum));
  }
}

/// Calculates the appropriate padding value
double _calculatePadding(bool shouldApply, double systemPadding, double minimumPadding) =>
    shouldApply ? systemPadding + minimumPadding : minimumPadding;
