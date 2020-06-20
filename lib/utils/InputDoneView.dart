import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputDoneView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topRight,
        child: FlatButton(
          padding: EdgeInsets.only(right: 0.0, top: 8.0, bottom: 0.0),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            alignment: Alignment.center,
            width: 100.0,
            padding: EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPeachDark()),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
            ),
            child: Text(
              "Done",
              style: TextStyle(
                color: Color(ColorConstants.getPrimaryWhite()),
                fontSize: 24.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}