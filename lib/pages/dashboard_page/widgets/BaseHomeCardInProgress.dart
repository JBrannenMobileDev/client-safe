import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
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
        margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 18.0),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cardTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Blackjack',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Text(
                    "View all",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConstants.primary_black),
                    ),
                  )
                ],
              ),
            ),
            jobs.length > 0 ? Container(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                reverse: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                key: _listKey,
                //                itemCount: pageState.currentJobs.length < 6 ? pageState.currentJobs.length : 5,
                itemCount: jobs.length,
                itemBuilder: _buildItem,
              ),
            ) : Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 26.0, right: 26.0),
              height: 64.0,
              child: Text(
                "You don't have any upcoming jobs. After a job is started it will appear here.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Raleway',
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
    return JobInProgressItem(job: jobs.elementAt(index));
  }

}