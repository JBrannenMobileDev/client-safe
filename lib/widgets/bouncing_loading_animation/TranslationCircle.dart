import 'package:client_safe/widgets/bouncing_loading_animation/Circle.dart';
import 'package:flutter/material.dart';

class TranslationCircle extends AnimatedWidget {
  final List<Animation<Offset>> animations;
  final AnimationController controller;

  TranslationCircle({
    Key key,
    @required this.controller,
    @required this.animations,
  }) : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return new SlideTransition(
      position: animations[0],
      child: new SlideTransition(
        position: animations[1],
        child: new Circle(),
      ),
    );
  }
}