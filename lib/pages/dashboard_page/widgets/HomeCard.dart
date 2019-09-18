import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

class HomeCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
      color: Color(ColorConstants.primary_bg_grey),
      child: Container(
        height: 200.0,
        decoration: new BoxDecoration(
            color: Color(ColorConstants.white),
            borderRadius: new BorderRadius.all(
                Radius.circular(8.0)
            )
        ),
      ),
    );
  }

}