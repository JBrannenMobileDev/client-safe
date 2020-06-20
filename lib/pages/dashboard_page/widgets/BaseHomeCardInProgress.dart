import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:dandylight/pages/home_page/HomePage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseHomeCardInProgress extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  BaseHomeCardInProgress({
    this.cardTitle,
    this.pageState,
    this.jobs});

  final String cardTitle;
  final DashboardPageState pageState;
  final List<Job> jobs;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: new BorderRadius.all(Radius.circular(24.0))),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cardTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      pageState.onViewAllHideSelected();
                    },
                    child: Text(
                      pageState.upcomingJobs.length > 3 ? (pageState.isMinimized ? 'View all (' + pageState.upcomingJobs.length.toString() + ')' : 'Hide') : '',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w400,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            jobs.length > 0 ? Container(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 16.0),
                reverse: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                key: _listKey,
                itemCount: jobs.length,
                itemBuilder: _buildItem,
              ),
            ) : Container(
              margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 16.0, right: 16.0),
              height: 64.0,
              child: Text(
                "You don't have any upcoming jobs. After a date has been selected the job will show up here.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return JobInProgressItem(job: jobs.elementAt(index), pageState: pageState);
  }

}