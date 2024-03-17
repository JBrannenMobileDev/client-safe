import 'dart:ui';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class InfoContainerWidget extends StatefulWidget {
  final Widget? contentWidget;

  InfoContainerWidget({this.contentWidget});

  @override
  State<StatefulWidget> createState() {
    return _InfoContainerWidget(contentWidget);
  }
}

class _InfoContainerWidget extends State<InfoContainerWidget> {
  final Widget? contentWidget;

  _InfoContainerWidget(this.contentWidget);

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.only(bottom: 16.0),
            alignment: Alignment.center,
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  width: 325,
                  height: 205,
                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
                  color: Color(ColorConstants.getPrimaryWhite()).withOpacity(1),
                  child: contentWidget,
                ),
              ),
            ),

    );
  }
}
