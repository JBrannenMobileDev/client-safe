import 'package:dandylight/widgets/bouncing_loading_animation/TranslationCircle.dart';
import 'package:flutter/material.dart';

class BouncingLoadingAnimatedIcon extends StatefulWidget {
  @override
  _BouncingLoadingAnimatedIcon createState() =>
      new _BouncingLoadingAnimatedIcon();
}

class _BouncingLoadingAnimatedIcon extends State<BouncingLoadingAnimatedIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Tween<Offset>? offsetTweenUp;
  Tween<Offset>? offsetTweenDown;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 800),
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

    _controller!.repeat().orCancel;
  }

  Animation<Offset> get stepOne => offsetTweenUp!.animate(
        new CurvedAnimation(
          parent: _controller!,
          curve: new Interval(
            0.0,
            0.17,
            curve: Curves.linear,
          ),
        ),
      );

  Animation<Offset> get stepTwoUp => offsetTweenUp!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.17,
        0.34,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepTwoDown => offsetTweenDown!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.17,
        0.34,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepThreeUp => offsetTweenUp!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.34,
        0.51,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepThreeDown => offsetTweenDown!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.34,
        0.51,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepFourUp => offsetTweenUp!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.51,
        0.68,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepFourDown => offsetTweenDown!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.51,
        0.68,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepFiveUp => offsetTweenUp!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.68,
        0.85,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepFiveDown => offsetTweenDown!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.68,
        0.85,
        curve: Curves.linear,
      ),
    ),
  );

  Animation<Offset> get stepSixDown => offsetTweenDown!.animate(
    new CurvedAnimation(
      parent: _controller!,
      curve: new Interval(
        0.85,
        1.0,
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
        child: new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TranslationCircle(controller: _controller!,
                animations: [
                  stepOne,
                  stepTwoDown,
                ],),
              new TranslationCircle(controller: _controller!,
                animations: [
                  stepTwoUp,
                  stepThreeDown,
                ],),
              new TranslationCircle(controller: _controller!,
                animations: [
                  stepThreeUp,
                  stepFourDown,
                ],),
              new TranslationCircle(controller: _controller!,
                animations: [
                  stepFourUp,
                  stepFiveDown,
                ],),
              new TranslationCircle(controller: _controller!,
                animations: [
                  stepFiveUp,
                  stepSixDown,
                ],),
            ],
          ),
        ),
    );
  }
}
