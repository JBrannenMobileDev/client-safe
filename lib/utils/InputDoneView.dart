import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/TextDandyLight.dart';

class InputDoneView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          style: Styles.getButtonStyle(top: 8.0),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            alignment: Alignment.center,
            width: 100.0,
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPeachDark()),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
            ),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: "Done",
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        ),
      ),
    );
  }
}