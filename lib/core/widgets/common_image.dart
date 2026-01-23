import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum CommonImageType {
  /// square
  square,

  /// horizontal rectangle
  hRectangle,

  /// vertical rectangle
  vRectangle,
}

class CommonImage extends StatelessWidget {
  final CommonImageType? type;
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? loadingBuilder;

  final Widget? errorWidgetChild;

  static String squareImg = 'assets/images/public/s_defaultImg.png';
  static String hRectangleImg = 'assets/images/public/h_defaultImg.png';
  static String vRectangleImg = 'assets/images/public/v_defaultImg.png';

  static const int Image_Maxnum = 50;
  static const int Image_Livenum = 50;

  const CommonImage(
    this.url, {
    super.key,
    this.type,
    this.width,
    this.height,
    this.fit,
    this.loadingBuilder,
    this.errorWidgetChild,
  });

  String get defaultImg {
    if (type == CommonImageType.square) return squareImg;
    if (type == CommonImageType.vRectangle) return vRectangleImg;
    if (type == CommonImageType.hRectangle) return hRectangleImg;
    if (width != null && height != null) {
      return width! > height!
          ? hRectangleImg
          : width == height
          ? squareImg
          : vRectangleImg;
    }
    return hRectangleImg;
  }

  void _checkMemory() {
    ImageCache imageCache = PaintingBinding.instance.imageCache;

    /// Because images have a local cache mechanism to prevent memory overflow
    if (imageCache.currentSizeBytes >= 55 << 20 ||
        imageCache.currentSize >= Image_Maxnum ||
        imageCache.liveImageCount >= Image_Livenum) {
      imageCache.clear();
      imageCache.clearLiveImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Image.asset(
        defaultImg,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }
    if (url.startsWith('assets/') || url.startsWith('lib/')) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidgetChild ?? Image.asset(defaultImg, fit: BoxFit.cover),
      );
    }
    _checkMemory();
    return CachedNetworkImage(
      // imageUrl: CommonUtils.formatImg(url),
      imageUrl: url,
      placeholder:
          loadingBuilder ??
          (context, url) => Image.asset(defaultImg, fit: BoxFit.cover),
      errorWidget: (context, url, error) =>
          errorWidgetChild ?? Image.asset(defaultImg, fit: BoxFit.cover),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
