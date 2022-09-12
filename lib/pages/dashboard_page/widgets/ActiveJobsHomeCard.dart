import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/BaseHomeCardInProgress.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/NavigationUtil.dart';

class ActiveJobsHomeCard extends StatelessWidget {
  ActiveJobsHomeCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationUtil.onStageStatsSelected(context, pageState, pageState.activeJobs, 'Active Jobs');
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        height: 64.0,
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: new BorderRadius.all(Radius.circular(24.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 18.0, left: 16.0),
                  height: 28.0,
                  width: 28.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/icons/briefcase_icon_peach_dark.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  'Active Jobs',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    pageState.activeJobs.length.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
