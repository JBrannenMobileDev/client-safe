import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class NotificationTile extends StatelessWidget {
  NotificationTile({this.title, this.content, this.count});

  final String title;
  final String content;
  final String count;

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
        child: Column(
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
                    color: const Color(ColorConstants.primary_accent)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Text(
                count,
                style: TextStyle(
                    fontSize: 72.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                    color: const Color(ColorConstants.primary_dark)),
              ),
            ),
          ],
        ));
  }
}
