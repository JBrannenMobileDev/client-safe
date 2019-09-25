import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'JobListItem.dart';

class JobsHomeCard extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  JobsHomeCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 60.0),
            height: 215.0,
            color: Color(ColorConstants.primary_bg_grey),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            padding: EdgeInsets.only(bottom: 16.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.white),
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
                        "Current Jobs",
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
                ListView.builder(
                  reverse: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: _listKey,
                  //                itemCount: pageState.currentJobs.length < 6 ? pageState.currentJobs.length : 5,
                  itemCount: 2,
                  itemBuilder: _buildItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
//    return JobListItem(job: pageState.currentJobs.elementAt(index));
    return JobListItem(
        job: Job(
            jobTitle: "Sunflower Shoot",
            clientName: "Allie Graham",
            type: Job.JOB_TYPE_ANNIVERSARY,
            lengthInHours: 1,
            price: 350.0,
            dateTime: DateTime(2019, 10, 5, 18)));
  }
}
