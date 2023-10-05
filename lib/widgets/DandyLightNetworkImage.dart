import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/utils/DandylightCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../utils/ColorConstants.dart';

class DandyLightNetworkImage extends StatelessWidget {
  static const String ERROR_TYPE_INTERNET = "internet";
  static const String ERROR_TYPE_NO_IMAGE = "no_image";
  static const String ERROR_TYPE_PLUS = "plus";
  final String imageUrl;
  final Color color;
  final Color errorIconColor;
  final double borderRadius;
  final int resizeWidth;
  final double errorIconSize;
  final BoxFit fit;
  final String errorType;

  DandyLightNetworkImage(
    this.imageUrl,
    {
      this.color = const Color(ColorConstants.peach_light),
      this.errorIconColor = const Color(ColorConstants.white),
      this.borderRadius = 8,
      this.resizeWidth = 650,
      this.errorIconSize = 44,
      this.fit = BoxFit.cover,
      this.errorType = DandyLightNetworkImage.ERROR_TYPE_INTERNET,
    }
  );

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        cacheManager: DandylightCacheManager.instance,
        fadeInDuration: Duration(milliseconds: 200),
        fadeOutDuration: Duration(milliseconds: 400),
        memCacheWidth: 650,
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: new BorderRadius.circular(borderRadius),
            image: DecorationImage(
              image: ResizeImage(imageProvider, width: resizeWidth),
              fit: fit,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.circular(borderRadius),
            )
        ),
        errorWidget: (context, url, error) => Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.circular(borderRadius),
            ),
            child: getErrorImage(errorType),
        ),
    );
  }

  Widget getErrorImage(String errorType) {
    Widget result = Image.asset(
      'assets/images/icons/no_wifi.png',
      color: errorIconColor,
      width: errorIconSize,
    );
    switch(errorType) {
      case ERROR_TYPE_INTERNET:
        result = Image.asset(
          'assets/images/icons/no_wifi.png',
          color: errorIconColor,
          width: errorIconSize,
        );
        break;
      case ERROR_TYPE_NO_IMAGE:
        result = Image.asset(
          'assets/images/icons/no_pictures.png',
          color: errorIconColor,
          width: errorIconSize,
        );
        break;
      case ERROR_TYPE_PLUS:
        result = Image.asset(
            "assets/images/icons/plus.png",
          color: errorIconColor,
          width: errorIconSize,
        );
        break;
      default:
        result = Image.asset(
          'assets/images/icons/no_wifi.png',
          color: errorIconColor,
          width: errorIconSize,
        );
    }
    return Container(
      width: errorIconSize,
      child: result,
    );
  }

}