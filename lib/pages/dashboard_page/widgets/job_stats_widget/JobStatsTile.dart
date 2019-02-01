import 'package:client_safe/pages/dashboard_page/widgets/job_stats_widget/Bar.dart';
import 'package:client_safe/pages/dashboard_page/widgets/job_stats_widget/BarTitle.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class JobStatsTile extends StatelessWidget {
  JobStatsTile({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 500.0),
        height: 150.0,
        decoration: BoxDecoration(
          color: const Color(ColorConstants.primary_bg_grey),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: ElevationToShadow.values.elementAt(1),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 4.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: const Color(ColorConstants.primary),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Bar(num: 2, height: 20.0),
                  Bar(num: 4, height: 40.0),
                  Bar(num: 1, height: 10.0),
                  Bar(num: 5, height: 50.0),
                  Bar(num: 7, height: 70.0),
                  Bar(num: 2, height: 20.0),
                ],
              ),
            ),
            Container(
                height: 48.0,
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(ColorConstants.primary),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BarTitle(barName: "Aug"),
                    BarTitle(barName: "Sept"),
                    BarTitle(barName: "Oct"),
                    BarTitle(barName: "Nov"),
                    BarTitle(barName: "Dec"),
                    BarTitle(barName: "Jan"),
                  ],
                ),
              ),
          ],
        )
    );
  }
}
