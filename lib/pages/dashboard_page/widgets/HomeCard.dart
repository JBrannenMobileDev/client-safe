import 'package:client_safe/models/Job.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

import 'BaseHomeCard.dart';
import 'JobListItem.dart';

class HomeCard extends StatelessWidget{
  HomeCard({
    this.cardTitle,
    this.listItemWidget});

  final String cardTitle;
  final Widget listItemWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(ColorConstants.primary_bg_grey),
      child: BaseHomeCard(
        cardTitle: "Notifications",
        listItemWidget: JobListItem(
            job: Job(
                jobTitle: "Sunflower Shoot",
                clientName: "Allie Graham",
                type: Job.JOB_TYPE_ANNIVERSARY,
                lengthInHours: 1,
                price: 350.0,
                dateTime: DateTime(2019, 10, 5, 18))),
      ),
    );
  }
}