import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RemindersCard extends StatelessWidget {
  RemindersCard({this.pageState});

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 26.0, bottom: 200.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
              height: 168.0,
          ),
          Container(
            width: double.maxFinite,
            height: 208.0,
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 0.0),
                      child: Text(
                        'Reminders',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  onPressed: null,
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                              tooltip: '3 Month Checkin',
                              onPressed: null,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                '3 Month Checkin',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/trash_icon_peach.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                              tooltip: 'Start Preparing',
                              onPressed: () {

                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Start Preparing',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/trash_icon_peach.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                              tooltip: '1 Week until wedding',
                              onPressed: () {

                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                '1 Week until wedding',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/trash_icon_peach.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
