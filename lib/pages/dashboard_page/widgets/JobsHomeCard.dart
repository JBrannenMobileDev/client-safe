import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/BaseHomeCard.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'JobListItem.dart';

class JobsHomeCard extends StatelessWidget {
  JobsHomeCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            margin: EdgeInsets.only(top: 60.0),
            height: Device.get().isIphoneX ? 208.0 : 188.0,
            color: Color(ColorConstants.primary_bg_grey),
          ),
          BaseHomeCard(
            cardTitle: "Upcoming Jobs",
            listItemWidget: JobListItem(
                job: Job(
                    jobTitle: "Sunflower Shoot",
                    clientName: "Allie Graham",
                    type: Job.JOB_TYPE_ANNIVERSARY,
                    lengthInHours: 1,
                    price: 350.0,
                    dateTime: DateTime(2019, 10, 5, 18))),
          ),
        ],
      ),
    );
  }
}
