import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    required this.imageUrl,
    super.key,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    final int? cacheWidth = width == null ? null : (width! * context.devicePixelRatio).toInt();
    final int? cacheHeight = height == null ? null : (height! * context.devicePixelRatio).toInt();
    return CachedNetworkImage(
      fit: fit,
      width: width,
      height: height,
      cacheKey: imageUrl,
      imageUrl: imageUrl,

      ///
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,

      ///
      maxWidthDiskCache: cacheWidth,
      maxHeightDiskCache: cacheHeight,
      placeholder: placeholder,
      errorWidget: errorWidget,
      imageBuilder: imageBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('imageUrl', imageUrl))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height))
      ..add(EnumProperty<BoxFit?>('fit', fit))
      ..add(ObjectFlagProperty<ImageWidgetBuilder?>.has('imageBuilder', imageBuilder))
      ..add(ObjectFlagProperty<PlaceholderWidgetBuilder?>.has('placeholder', placeholder))
      ..add(ObjectFlagProperty<ProgressIndicatorBuilder?>.has('progressIndicatorBuilder', progressIndicatorBuilder))
      ..add(ObjectFlagProperty<LoadingErrorWidgetBuilder?>.has('errorWidget', errorWidget));
  }
}

class CustomImageCacheManager extends CacheManager with ImageCacheManager {
  CustomImageCacheManager._internal()
    : super(
        Config(
          StorageKeys.imageCache,
          maxNrOfCacheObjects: 500,
          fileService: HttpFileService(),
          stalePeriod: const Duration(days: 30),
          repo: JsonCacheInfoRepository(databaseName: StorageKeys.imageCache),
        ),
      );

  static CacheManager instance = _instance;

  static final CustomImageCacheManager _instance = CustomImageCacheManager._internal();
}
