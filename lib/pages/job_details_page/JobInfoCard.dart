
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/BaseHomeCardInProgress.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobInfoCard extends StatelessWidget {
  JobInfoCard({this.pageState});

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
      padding: EdgeInsets.only(top: 26.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
              height: 260.0,
            color: Color(ColorConstants.getPrimaryBackgroundGrey())
          ),
          Container(
            height: 260.0,
            width: double.maxFinite,
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 0.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                  child: Text(
                          'Job Info',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Blackjack',
                            fontWeight: FontWeight.w800,
                            color: Color(ColorConstants.primary_black),
                        ),
                  ),
                ),
                Container(
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                  Icons.calendar_today,
                                  color: Color(ColorConstants.getCollectionColor1()),
                              ),
                              tooltip: 'Date',
                              onPressed: () {

                              },
                            ),
                            Container(
                              width: 200.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                (pageState.job.selectedDate != null
                                    ? DateFormat('EEE, MMM d').format(pageState.job
                                    .selectedDate)
                                    : ''),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(ColorConstants.getCollectionColor1()),
                          ),
                          tooltip: 'Edit',
                          onPressed: () {

                          },
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height: MediaQuery.of(context).copyWith().size.height / 3,
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (DateTime time) {
                                vibrate();
                                _onConfirmedTime(time, pageState);
                              },
                              use24hFormat: false,
                              minuteInterval: 1,
                              mode: CupertinoDatePickerMode.time,
                            ),
                          );
                        });
                  },
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
                                  Icons.access_time,
                                  color: Color(ColorConstants.getCollectionColor1()),
                                ),
                                tooltip: 'Time',
                                onPressed: () {

                                },
                              ),
                              Container(
                                width: 200.0,
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (pageState.job.selectedTime != null
                                      ? DateFormat('h:mm a').format(pageState.job
                                      .selectedTime)
                                      : ''),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.primary_black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(ColorConstants.getCollectionColor1()),
                            ),
                            tooltip: 'Edit',
                            onPressed: null,
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.location_on,
                                color: Color(ColorConstants.getCollectionColor1()),
                              ),
                              tooltip: 'Location',
                              onPressed: () {

                              },
                            ),
                            Container(
                              width: 200.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                pageState.job.location.locationName,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(ColorConstants.getCollectionColor1()),
                          ),
                          tooltip: 'Edit',
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.attach_money,
                                color: Color(ColorConstants.getCollectionColor1()),
                              ),
                              tooltip: 'Pricing package',
                              onPressed: () {

                              },
                            ),
                            Container(
                              width: 200.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                pageState.job.priceProfile.profileName + ' package',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(ColorConstants.getCollectionColor1()),
                          ),
                          tooltip: 'Edit',
                          onPressed: () {

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }

  void _onConfirmedTime(DateTime time, JobDetailsPageState pageState) {

  }
}
