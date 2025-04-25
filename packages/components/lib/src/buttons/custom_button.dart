import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CustomLabelButton { label, icon }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.onPressed,
    this.height = 48,
  });

  final Widget label;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));

    /// Label
    final Widget labelA = DefaultTextStyle(
      style: const TextStyle(
        height: 20 / 15,
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      child: label,
    );

    /// Icon
    final Widget childA;
    if (leftIcon != null || rightIcon != null) {
      childA = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (leftIcon != null)
            IconTheme(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: leftIcon!,
            ),
          if (leftIcon != null) const SizedBox(width: 8),
          labelA,
          if (rightIcon != null) const SizedBox(width: 8),
          if (rightIcon != null)
            IconTheme(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: rightIcon!,
            ),
        ],
      );
    } else {
      childA = labelA;
    }
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: DecoratedBox(
        decoration: context.shapes.buttonDecoration,
        child: Container(
          margin: const EdgeInsets.all(1),
          height: height - 1,
          alignment: Alignment.center,
          decoration: context.shapes.buttonsShadowDecoration,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: childA,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed))
      ..add(DoubleProperty('height', height));
  }
}
