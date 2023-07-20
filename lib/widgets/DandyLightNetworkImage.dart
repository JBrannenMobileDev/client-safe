import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../utils/ColorConstants.dart';

class DandyLightNetworkImage extends StatelessWidget {
  final String imageUrl;
  final Color color;
  final Color errorIconColor;
  final double borderRadius;
  final int resizeWidth;
  final double errorIconSize;
  final BoxFit fit;

  DandyLightNetworkImage(
    this.imageUrl,
    {
      this.color = const Color(ColorConstants.peach_light),
      this.errorIconColor = const Color(ColorConstants.white),
      this.borderRadius = 8,
      this.resizeWidth = 650,
      this.errorIconSize = 44,
      this.fit = BoxFit.cover,
    }
  );

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        fadeInDuration: Duration(milliseconds: 200),
        fadeOutDuration: Duration(milliseconds: 400),
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
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.circular(borderRadius),
            ),
            child: Image.asset(
              'assets/images/icons/no_wifi.png',
              color: errorIconColor,
              width: errorIconSize,
            ),
            width: errorIconSize
        ),
    );
  }

}