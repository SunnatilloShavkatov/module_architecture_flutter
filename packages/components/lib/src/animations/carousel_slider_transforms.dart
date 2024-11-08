import "dart:math" as math;

import "package:flutter/material.dart";

const List<SlideTransform> slideTransforms = <SlideTransform>[
  CubeTransform(),
  DepthTransform(),
  AccordionTransform(),
  ZoomOutSlideTransform(),
  ForegroundToBackgroundTransform(),
  BackgroundToForegroundTransform(),
];

class CubeTransform implements SlideTransform {
  const CubeTransform({
    this.perspectiveScale = 0.0014,
    this.rightPageAlignment = Alignment.centerLeft,
    this.leftPageAlignment = Alignment.centerRight,
    double rotationAngle = 90,
  }) : rotationAngle = math.pi / 180 * rotationAngle;
  final double perspectiveScale;
  final AlignmentGeometry rightPageAlignment;
  final AlignmentGeometry leftPageAlignment;
  final double rotationAngle;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      return Transform(
        alignment: leftPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(rotationAngle * pageDelta),
        child: page,
      );
    } else if (index == currentPage! + 1) {
      return Transform(
        alignment: rightPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(-rotationAngle * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class AccordionTransform implements SlideTransform {
  const AccordionTransform({
    this.transformRight = true,
    this.transformLeft = true,
  });

  final bool transformRight;
  final bool transformLeft;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage && transformLeft) {
      return Transform(
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()..rotateY(math.pi / 2 * pageDelta),
        child: page,
      );
    }
    if (index == currentPage! + 1 && transformRight) {
      return Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()..rotateY(-math.pi / 2 * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class BackgroundToForegroundTransform implements SlideTransform {
  const BackgroundToForegroundTransform({
    this.startScale = 0.4,
  });

  final double startScale;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage! + 1) {
      final double scale = startScale + (1 - startScale) * pageDelta;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class ForegroundToBackgroundTransform implements SlideTransform {
  const ForegroundToBackgroundTransform({this.endScale = 0.4});

  final double endScale;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      final double scale = endScale + (1 - endScale) * (1 - pageDelta);
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class DefaultTransform implements SlideTransform {
  const DefaultTransform();

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) =>
      page;
}

class DepthTransform implements SlideTransform {
  const DepthTransform({
    this.startScale = 0.4,
  });

  final double startScale;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      final double scale = startScale + (1 - startScale) * (1 - pageDelta);
      final double width = MediaQuery.of(context).size.width;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(width * pageDelta)
          ..scale(scale, scale),
        child: Opacity(
          opacity: 1 - pageDelta,
          child: page,
        ),
      );
    } else {
      return page;
    }
  }
}

class FlipHorizontalTransform implements SlideTransform {
  const FlipHorizontalTransform({
    this.perspectiveScale = 0.002,
  });

  final double perspectiveScale;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    final double width = MediaQuery.of(context).size.width;
    if (index == currentPage! + 1 && pageDelta > 0.5) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(math.pi * (pageDelta - 1))
          ..leftTranslate(-width * (1 - pageDelta)),
        child: page,
      );
    } else if (index == currentPage && pageDelta <= 0.5) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(math.pi * pageDelta)
          ..leftTranslate(width * pageDelta),
        child: page,
      );
    } else if (pageDelta == 0) {
      return page;
    } else {
      return Container();
    }
  }
}

class FlipVerticalTransform implements SlideTransform {
  const FlipVerticalTransform({
    this.perspectiveScale = 0.002,
  });

  final double perspectiveScale;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    final double width = MediaQuery.of(context).size.width;
    if (index == currentPage! + 1 && pageDelta > 0.5) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateX(math.pi * (pageDelta - 1))
          ..leftTranslate(-width * (1 - pageDelta)),
        child: page,
      );
    } else if (index == currentPage && pageDelta <= 0.5) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateX(math.pi * pageDelta)
          ..leftTranslate(width * pageDelta),
        child: page,
      );
    } else if (pageDelta == 0) {
      return page;
    } else {
      return Container();
    }
  }
}

class ParallaxTransform implements SlideTransform {
  const ParallaxTransform({
    this.clipAmount = 200,
  });

  final double clipAmount;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage! + 1) {
      return Transform.translate(
        offset: Offset(-clipAmount * (1 - pageDelta), 0),
        child: ClipRect(
          clipper: RectClipper(clipAmount * (1 - pageDelta)),
          child: page,
        ),
      );
    } else {
      return page;
    }
  }
}

class RectClipper extends CustomClipper<Rect> {
  const RectClipper(this.leftClip);

  final double leftClip;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(leftClip, 0, size.width, size.height);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class StackTransform implements SlideTransform {
  const StackTransform();

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      final double width = MediaQuery.of(context).size.width;
      return Transform(
        transform: Matrix4.identity()..translate(width * pageDelta),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class TabletTransform implements SlideTransform {
  const TabletTransform();

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(-math.pi / 4 * pageDelta),
        child: page,
      );
    } else if (index == currentPage! + 1) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(math.pi / 4 * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class RotateDownTransform implements SlideTransform {
  const RotateDownTransform({
    double rotationAngle = 45,
  }) : rotationAngle = math.pi / 180 * rotationAngle;
  final double rotationAngle;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      return Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()..rotateZ(-rotationAngle * pageDelta),
        child: page,
      );
    } else if (index == currentPage! + 1) {
      return Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()..rotateZ(rotationAngle * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class RotateUpTransform implements SlideTransform {
  const RotateUpTransform({
    double rotationAngle = 45,
  }) : rotationAngle = math.pi / 180 * rotationAngle;
  final double rotationAngle;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      return Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()..rotateZ(rotationAngle * pageDelta),
        child: page,
      );
    } else if (index == currentPage! + 1) {
      return Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..rotateZ(-rotationAngle * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class ZoomOutSlideTransform implements SlideTransform {
  const ZoomOutSlideTransform({
    this.zoomOutScale = 0.8,
    this.enableOpacity = true,
  });

  final double zoomOutScale;
  final bool enableOpacity;

  @override
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  ) {
    if (index == currentPage) {
      final double scale = 1 - pageDelta < zoomOutScale
          ? zoomOutScale
          : zoomOutScale + ((1 - pageDelta) - zoomOutScale);
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: enableOpacity ? Opacity(opacity: scale, child: page) : page,
      );
    } else if (index == currentPage! + 1) {
      final double scale = pageDelta < zoomOutScale
          ? zoomOutScale
          : zoomOutScale + (pageDelta - zoomOutScale);
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: enableOpacity ? Opacity(opacity: scale, child: page) : page,
      );
    } else {
      return page;
    }
  }
}

sealed class SlideTransform {
  Widget transform(
    BuildContext context,
    Widget page,
    int index,
    int? currentPage,
    double pageDelta,
    int itemCount,
  );
}
