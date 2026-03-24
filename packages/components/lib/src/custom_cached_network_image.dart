import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    required this.imageUrl,
    super.key,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.unsupportedImageBuilder,
    this.errorBuilder,
    this.httpHeaders,
    this.width,
    this.height,
    this.fit,
  }) : assert(
         placeholder == null || progressIndicatorBuilder == null,
         'placeholder and progressIndicatorBuilder cannot be used simultaneously.',
       );

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  /// HTTP headers to attach to the network request (e.g., Authorization token).
  final Map<String, String>? httpHeaders;

  /// Called after the image loads successfully to wrap it in a custom widget.
  final ImageWidgetBuilder? imageBuilder;

  /// Widget shown while the image is loading.
  /// Cannot be used together with [progressIndicatorBuilder].
  final PlaceholderWidgetBuilder? placeholder;

  /// Progress indicator widget shown during download.
  /// Cannot be used together with [placeholder].
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Fallback widget for formats unsupported by the Flutter codec (e.g. SVG).
  /// Receives the cached bytes directly — pass them to a renderer such as SvgPicture.memory().
  /// If not provided, the error falls through to [errorBuilder].
  final UnsupportedImageWidgetBuilder? unsupportedImageBuilder;

  /// Widget shown when the image fails to load.
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return CachedNetworkImage(
      fit: fit,
      width: width,
      height: height,
      cacheKey: imageUrl,
      imageUrl: imageUrl,
      httpHeaders: httpHeaders,
      // Decode in memory at device pixel density — disk cache keeps the original size.
      memCacheWidth: CustomImageCacheManager._toCacheSize(width, devicePixelRatio),
      memCacheHeight: CustomImageCacheManager._toCacheSize(height, devicePixelRatio),
      placeholder: placeholder,
      errorBuilder: errorBuilder,
      imageBuilder: imageBuilder,
      unsupportedImageBuilder: unsupportedImageBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      cacheManager: CustomImageCacheManager.cacheManager,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('imageUrl', imageUrl))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height))
      ..add(EnumProperty<BoxFit?>('fit', fit));
  }
}

final class CustomImageCacheManager {
  const CustomImageCacheManager._();

  /// Singleton cache manager — one instance shared across all widgets.
  /// Avoids memory leaks caused by creating a new manager on every build().
  static final DefaultCacheManager cacheManager = DefaultCacheManager(
    maxNrOfCacheObjects: 1000,
    stalePeriod: const Duration(days: 30),
    connectionParameters: ConnectionParameters(
      requestTimeout: const Duration(seconds: 30),
      connectionTimeout: const Duration(seconds: 10),
    ),
  );

  /// Converts a logical size to physical pixels for memory cache hints.
  /// Returns null if [size] is null or rounds to zero — preventing the decoder
  /// from producing a 0-sized image that would render as invisible.
  static int? _toCacheSize(double? size, double dpr) {
    if (size == null) {
      return null;
    }
    final px = (size * dpr).toInt();
    return px > 0 ? px : null;
  }
}
