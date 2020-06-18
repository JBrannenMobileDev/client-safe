import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';

class TranslationImage extends AnimatedWidget {
  final List<Animation<Offset>> animations;
  final AnimationController controller;
  final AssetImage image;

  TranslationImage({
    Key key,
    @required this.controller,
    @required this.animations,
    @required this.image,
  }) : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: animations[0],
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: image,
              fit: BoxFit.fill,
            ),
          ),
        ),
    );
  }
}
