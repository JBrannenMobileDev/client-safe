import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/BaseHomeCardInProgress.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/NavigationUtil.dart';

class StartAJobButton extends StatelessWidget {
  StartAJobButton({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserOptionsUtil.showNewJobDialog(context);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        height: 64.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getBlueDark()),
            borderRadius: new BorderRadius.all(Radius.circular(24.0))),
        child: Text(
          'START NEW JOB',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26.0,
            fontFamily: 'simple',
            fontWeight: FontWeight.w600,
            color: Color(ColorConstants.getPrimaryWhite()),
          ),
        ),
      ),
    );
  }
}
