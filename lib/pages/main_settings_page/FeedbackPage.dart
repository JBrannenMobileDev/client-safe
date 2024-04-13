import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../widgets/TextDandyLight.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 36.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 22.0),
                    height: 48.0,
                    width: 48.0,
                    child: Icon(
                      (Device.get().isIos ? CupertinoIcons.back : Icons.arrow_back),
                      size: 24.0,
                      color: Color(ColorConstants.getPeachLight()),
                    ),
                  ),
                ),
                TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Feedback',
                  color: Color(ColorConstants.getPeachLight()),
                ),
                SizedBox(width: 48.0,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}