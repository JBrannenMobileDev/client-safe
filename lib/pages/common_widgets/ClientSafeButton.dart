import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class ClientSafeButton extends StatelessWidget{
  final double? height;
  final double? width;
  final String? text;
  final double? marginLeft;
  final double? marginTop;
  final double? marginRight;
  final double? marginBottom;
  final Function? onPressed;
  final Icon? icon;
  final String? urlText;
  final int? color;

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
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: marginLeft!, top: marginTop!, right: marginRight!, bottom: marginBottom!),
      child: SizedBox(
        width: width,
        height: height,
        child: TextButton(
          style: Styles.getButtonStyle(
            shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(32.0),
                  side: BorderSide(color: Color(color!))),
            color: Color(color!),
            textColor: Color(ColorConstants.getPrimaryWhite()),
          ),
          onPressed: () => urlText!.length > 0 ? onPressed!(urlText) : onPressed!(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon != null ? IconButton(
                padding: EdgeInsets.all(0.0),
                icon: icon!,
                color: Color(ColorConstants.getPrimaryWhite()),
                onPressed: null,
              ) : SizedBox(),
              text!.isNotEmpty ? TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: text,
                color: Color(ColorConstants.getPrimaryWhite()),
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

}