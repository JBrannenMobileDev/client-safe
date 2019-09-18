import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

class HomeCardTop extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(ColorConstants.primary_bg_grey),
      child: Stack(
        children: <Widget>[
          Container(
            height: 60.0,
            color: Color(ColorConstants.primary),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            height: 200.0,
            decoration: new BoxDecoration(
                color: Color(ColorConstants.white),
                borderRadius: new BorderRadius.all(
                    Radius.circular(8.0)
                )
            ),
          )
        ],
      ),
    );
  }

}