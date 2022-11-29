import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';


class InfoContainerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InfoContainerWidget();
  }
}

class _InfoContainerWidget extends State<InfoContainerWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.only(bottom: 16.0),
            alignment: Alignment.center,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  width: 325,
                  height: 250,
                  padding: EdgeInsets.all(24),
                  color: Color(ColorConstants.getPrimaryWhite()).withOpacity(0.4),
                  child: SizedBox(),
                ),
              ),
            ),

    );
  }
}
