import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobListItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

class BaseHomeCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  BaseHomeCard({
    this.cardTitle,
    this.pageState});

  final String cardTitle;
  final DashboardPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cardTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Text(
                    "View all",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  )
                ],
              ),
            ),
            pageState.currentJobs.length > 0 ? Container(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                reverse: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                key: _listKey,
                //                itemCount: pageState.currentJobs.length < 6 ? pageState.currentJobs.length : 5,
                itemCount: pageState.currentJobs.length,
                itemBuilder: _buildItem,
              ),
            ) : Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 64.0, right: 64.0),
              height: 64.0,
              child: Text(
                "You don't have any upcoming jobs. After a job is started it will appear here.",
                textAlign: TextAlign.center,
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
    return JobListItem(job: pageState.currentJobs.elementAt(index));
  }

}