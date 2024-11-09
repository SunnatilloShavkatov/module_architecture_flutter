import "package:core/core.dart";
import "package:flutter/material.dart";

class OffstageStack extends StatelessWidget {
  const OffstageStack({super.key, required this.child, required this.isVisited});

  final bool isVisited;
  final Widget child;

  @override
  Widget build(BuildContext context) => Offstage(offstage: false, child: isVisited ? child : Dimensions.kGap);
}
