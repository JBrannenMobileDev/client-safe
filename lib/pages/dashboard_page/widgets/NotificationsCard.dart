import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationsCard extends StatelessWidget{
  NotificationsCard({this.pageState});

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
          )
        ],
      ),
    );
  }

}