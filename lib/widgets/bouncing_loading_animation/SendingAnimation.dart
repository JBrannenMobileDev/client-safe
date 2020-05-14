import 'package:client_safe/widgets/bouncing_loading_animation/SendingTranslationCircle.dart';
import 'package:flutter/material.dart';

class SendingAnimation extends StatefulWidget {
  @override
  _SendingAnimation createState() =>
      new _SendingAnimation();
}

class _SendingAnimation extends State<SendingAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<Offset> offsetTweenUp;
  Tween<Offset> offsetTweenDown;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    offsetTweenUp = new Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    );

    offsetTweenDown = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );

    _controller.repeat().orCancel;
  }

  Animation<Offset> get stepOne => offsetTweenUp.animate(
        new CurvedAnimation(
          parent: _controller,
          curve: new Interval(
            0.0,
            0.17,
            curve: Curves.linear,
          ),
        ),
      );

  Animation<Offset> get stepTwoUp => offsetTweenUp.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.17,
        0.34,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepTwoDown => offsetTweenDown.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.17,
        0.34,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepThreeUp => offsetTweenUp.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.34,
        0.51,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepThreeDown => offsetTweenDown.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.34,
        0.51,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepFourDown => offsetTweenDown.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.51,
        0.68,
        curve: Curves.linear,
      ),
    ),
  );

  // This is important for perf. When the widget is gone, remove the controller.
  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 46.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new SendingTranslationCircle(controller: _controller,
            animations: [
              stepOne,
              stepTwoDown,
            ],),
          new SendingTranslationCircle(controller: _controller,
            animations: [
              stepTwoUp,
              stepThreeDown,
            ],),
          new SendingTranslationCircle(controller: _controller,
            animations: [
              stepThreeUp,
              stepFourDown,
            ],),
        ],
      ),
    );
  }
}
