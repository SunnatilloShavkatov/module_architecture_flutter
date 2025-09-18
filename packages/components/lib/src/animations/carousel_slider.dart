import 'dart:async';

import 'package:components/src/animations/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

export 'carousel_slider_transforms.dart';

const int _kMaxValue = 200000000000;
const int _kMiddleValue = 100000;

typedef CarouselSlideBuilder = Widget Function(int index);

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    required List<Widget> this.children,
    super.key,
    this.slideTransform = const DefaultTransform(),
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderDelay = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 1),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.onSlideChanged,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
    this.findChildIndexCallback,
  }) : slideBuilder = null,
       itemCount = children.length;

  const CarouselSlider.builder({
    required this.slideBuilder,
    required this.itemCount,
    super.key,
    this.slideTransform = const DefaultTransform(),
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderDelay = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 1),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.onSlideChanged,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
    this.findChildIndexCallback,
  }) : children = null;

  final CarouselSlideBuilder? slideBuilder;
  final List<Widget>? children;
  final int itemCount;
  final SlideTransform slideTransform;
  final double viewportFraction;
  final bool enableAutoSlider;

  /// Waiting time before starting the auto slider
  final Duration autoSliderDelay;

  final Duration autoSliderTransitionTime;
  final Curve autoSliderTransitionCurve;
  final bool unlimitedMode;
  final bool keepPage;
  final ScrollPhysics scrollPhysics;
  final Axis scrollDirection;
  final int initialPage;
  final ValueChanged<int>? onSlideChanged;
  final Clip clipBehavior;
  final CarouselSliderController? controller;
  final ChildIndexGetter? findChildIndexCallback;

  @override
  State<StatefulWidget> createState() => _CarouselSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<CarouselSlideBuilder?>.has('slideBuilder', slideBuilder))
      ..add(IntProperty('itemCount', itemCount))
      ..add(DiagnosticsProperty<SlideTransform>('slideTransform', slideTransform))
      ..add(DoubleProperty('viewportFraction', viewportFraction))
      ..add(DiagnosticsProperty<bool>('enableAutoSlider', enableAutoSlider))
      ..add(DiagnosticsProperty<Duration>('autoSliderDelay', autoSliderDelay))
      ..add(DiagnosticsProperty<Duration>('autoSliderTransitionTime', autoSliderTransitionTime))
      ..add(DiagnosticsProperty<Curve>('autoSliderTransitionCurve', autoSliderTransitionCurve))
      ..add(DiagnosticsProperty<bool>('unlimitedMode', unlimitedMode))
      ..add(DiagnosticsProperty<bool>('keepPage', keepPage))
      ..add(DiagnosticsProperty<ScrollPhysics>('scrollPhysics', scrollPhysics))
      ..add(EnumProperty<Axis>('scrollDirection', scrollDirection))
      ..add(IntProperty('initialPage', initialPage))
      ..add(ObjectFlagProperty<ValueChanged<int>?>.has('onSlideChanged', onSlideChanged))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<CarouselSliderController?>('controller', controller))
      ..add(ObjectFlagProperty<ChildIndexGetter?>.has('findChildIndexCallback', findChildIndexCallback));
  }
}

class CarouselSliderController {
  _CarouselSliderState? _state;

  Future<void> nextPage([Duration? transitionDuration]) async {
    if (_state != null && _state!.mounted) {
      await _state!._nextPage(transitionDuration);
    }
  }

  Future<void> previousPage([Duration? transitionDuration]) async {
    if (_state != null && _state!.mounted) {
      await _state!._previousPage(transitionDuration);
    }
  }

  void setAutoSliderEnabled({required bool isEnabled}) {
    if (_state != null && _state!.mounted) {
      _state!._setAutoSliderEnabled(isEnabled);
    }
  }

  void dispose() {
    if (_state != null && _state!.mounted) {
      _state!.dispose();
    }
  }
}

class _CarouselSliderState extends State<CarouselSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int? _currentPage;
  double _pageDelta = 0;
  late bool _isPlaying;

  @override
  Widget build(BuildContext context) => PageView.builder(
    onPageChanged: (int val) {
      widget.onSlideChanged?.call(val);
    },
    clipBehavior: widget.clipBehavior,
    scrollBehavior: ScrollConfiguration.of(context).copyWith(
      scrollbars: false,
      overscroll: false,
      dragDevices: <PointerDeviceKind>{PointerDeviceKind.touch, PointerDeviceKind.mouse},
    ),
    itemCount: widget.unlimitedMode ? _kMaxValue : widget.itemCount,
    controller: _pageController,
    scrollDirection: widget.scrollDirection,
    physics: widget.scrollPhysics,
    findChildIndexCallback: widget.findChildIndexCallback,
    itemBuilder: (BuildContext context, int index) {
      final int slideIndex = index % widget.itemCount;
      final Widget slide = widget.children == null ? widget.slideBuilder!(slideIndex) : widget.children![slideIndex];
      return widget.slideTransform.transform(context, slide, index, _currentPage, _pageDelta, widget.itemCount);
    },
  );

  @override
  void didUpdateWidget(covariant CarouselSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enableAutoSlider != widget.enableAutoSlider) {
      _setAutoSliderEnabled(widget.enableAutoSlider);
    }
    if (oldWidget.itemCount != widget.itemCount) {
      _initPageController();
    }
    _initCarouselSliderController();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.enableAutoSlider;
    _currentPage = widget.initialPage;
    _initCarouselSliderController();
    _initPageController();
    _setAutoSliderEnabled(_isPlaying);
  }

  void _initCarouselSliderController() {
    if (widget.controller != null) {
      widget.controller!._state = this;
    }
  }

  void _initPageController() {
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      keepPage: widget.keepPage,
      initialPage: widget.unlimitedMode ? _kMiddleValue * widget.itemCount + _currentPage! : _currentPage!,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.floor();
        _pageDelta = _pageController.page! - _pageController.page!.floor();
      });
    });
  }

  Future<void> _nextPage(Duration? transitionDuration) async {
    await _pageController.nextPage(
      duration: transitionDuration ?? widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  Future<void> _previousPage(Duration? transitionDuration) async {
    await _pageController.previousPage(
      duration: transitionDuration ?? widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void _setAutoSliderEnabled(bool isEnabled) {
    if (_timer != null) {
      _timer?.cancel();
    }
    if (isEnabled) {
      _timer = Timer.periodic(widget.autoSliderDelay, (Timer timer) async {
        await _pageController.nextPage(
          duration: widget.autoSliderTransitionTime,
          curve: widget.autoSliderTransitionCurve,
        );
      });
    }
  }
}
