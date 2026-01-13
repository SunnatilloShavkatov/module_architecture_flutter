import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final int? cacheWidth = width == null ? null : (width! * devicePixelRatio).toInt();
    final int? cacheHeight = height == null ? null : (height! * devicePixelRatio).toInt();
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

const String _imageCache = 'image_cache';

class CustomImageCacheManager extends CacheManager with ImageCacheManager {
  CustomImageCacheManager._internal()
    : super(
        Config(
          _imageCache,
          maxNrOfCacheObjects: 500,
          fileService: HttpFileService(),
          stalePeriod: const Duration(days: 30),
          repo: JsonCacheInfoRepository(databaseName: _imageCache),
        ),
      );

  static CacheManager instance = _instance;

  static final CustomImageCacheManager _instance = CustomImageCacheManager._internal();
}
