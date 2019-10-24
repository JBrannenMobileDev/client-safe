import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClientSafeButton extends StatelessWidget{
  final double height;
  final double width;
  final String text;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final Function onPressed;
  final Icon icon;
  final String urlText;

  ClientSafeButton({
    this.height,
    this.width,
    this.text,
    this.marginLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.onPressed,
    this.icon,
    this.urlText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: marginLeft, top: marginTop, right: marginRight, bottom: marginBottom),
      child: SizedBox(
        width: width,
        height: height,
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
              side: BorderSide(color: Color(ColorConstants.primary))),
          onPressed: () => onPressed(urlText),
          color: Color(ColorConstants.primary),
          textColor: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon != null ? IconButton(
                padding: EdgeInsets.all(0.0),
                icon: icon,
                color: Colors.white,
                onPressed: null,
              ) : SizedBox(),
              text.isNotEmpty ? Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  color: Colors.white,
                ),
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

}