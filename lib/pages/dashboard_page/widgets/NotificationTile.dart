import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class NotificationTile extends StatelessWidget {
  NotificationTile(
      {this.title,
      this.content1,
      this.content2,
      this.count,
      this.hasNewNotification});

  final String title;
  final String content1;
  final String content2;
  final String count;
  final bool hasNewNotification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: const Color(ColorConstants.primary_bg_grey),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: ElevationToShadow.values.elementAt(1),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 4.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: hasNewNotification
                      ? const Color(ColorConstants.primary_accent)
                      : const Color(ColorConstants.primary)),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            alignment: Alignment.topCenter,
            child: Text(
              count,
              style: TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: hasNewNotification
                      ? const Color(ColorConstants.primary_accent)
                      : const Color(ColorConstants.primary)),
            ),
          ),
          Container(
            height: 35.0,
            margin: EdgeInsets.fromLTRB(0.0, 65.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: hasNewNotification
                  ? const Color(ColorConstants.primary_accent)
                  : const Color(ColorConstants.primary),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  content1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  content2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
