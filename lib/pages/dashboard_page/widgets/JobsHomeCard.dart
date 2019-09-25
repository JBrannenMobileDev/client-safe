import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'JobListItem.dart';

class JobsHomeCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  JobsHomeCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 140.0,
            color: Color(ColorConstants.primary_bg_grey),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            height: 200.0,
            decoration: new BoxDecoration(
                color: Color(ColorConstants.white),
                borderRadius: new BorderRadius.all(
                    Radius.circular(8.0)
                )
            ),
            child: ListView.builder(
                reverse: false,
                padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                key: _listKey,
//                itemCount: pageState.currentJobs.length < 6 ? pageState.currentJobs.length : 5,
                itemCount: 2,
                itemBuilder: _buildItem,
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
//    return JobListItem(job: pageState.currentJobs.elementAt(index));


    return JobListItem(job: Job(
      jobTitle: "Sunflower Shoot",
      clientName: "Allie ",
      type: Job.JOB_TYPE_ANNIVERSARY,
      lengthInHours: 1,
      price: 350.0,
      dateTime: DateTime(2019, 10, 5, 18)
    ));
  }
}