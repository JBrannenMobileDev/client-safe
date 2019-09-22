import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

class HomeCard extends StatelessWidget{
  HomeCard({
    this.paddingLeft,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.cardHeight,
    this.cardContents});

  final double paddingLeft;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double cardHeight;
  final Widget cardContents;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
      color: Color(ColorConstants.primary_bg_grey),
      child: Container(
        height: cardHeight,
        decoration: new BoxDecoration(
            color: Color(ColorConstants.white),
            borderRadius: new BorderRadius.all(
                Radius.circular(8.0)
            )
        ),
        child: cardContents,
      ),
    );
  }

}