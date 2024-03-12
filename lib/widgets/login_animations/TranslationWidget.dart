import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';

class TranslationWidget extends AnimatedWidget {
  final List<Animation<Offset>> animations;
  final AnimationController controller;
  final Widget widget;

  TranslationWidget({
    Key? key,
    required this.controller,
    required this.animations,
    required this.widget,
  }) : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: animations[0],
        child: widget,
    );
  }
}
