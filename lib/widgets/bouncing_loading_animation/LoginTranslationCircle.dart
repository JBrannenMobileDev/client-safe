import 'package:dandylight/widgets/bouncing_loading_animation/Circle.dart';
import 'package:dandylight/widgets/bouncing_loading_animation/LoginCircle.dart';
import 'package:flutter/material.dart';

class LoginTranslationCircle extends AnimatedWidget {
  final List<Animation<Offset>> animations;
  final AnimationController controller;

  LoginTranslationCircle({
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
        child: new LoginCircle(),
      ),
    );
  }
}
