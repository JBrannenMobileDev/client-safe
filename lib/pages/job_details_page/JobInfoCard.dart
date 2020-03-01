
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/BaseHomeCardInProgress.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobInfoCard extends StatelessWidget {
  JobInfoCard({this.pageState});

  final JobDetailsPageState pageState;

  DateTime newDateTimeHolder;

  @override
  Widget build(BuildContext context) {
    newDateTimeHolder = pageState.job.selectedTime;
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40.0),
            height: 314.0,
            color: Color(ColorConstants.getPrimaryBackgroundGrey())
          ),
          Container(
            height: 354.0,
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
                FlatButton(
                  onPressed: () {
                    UserOptionsUtil.showNameChangeDialog(context);
                  },
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 86.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Job name:',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                pageState.job.jobTitle,
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
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                          tooltip: 'Edit',
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    UserOptionsUtil.showJobTypeChangeDialog(context);
                  },
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 78.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Job type:',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                pageState.job.getJobType(),
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
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                          tooltip: 'Edit',
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    UserOptionsUtil.showDateSelectionCalendarDialog(context);
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
                                  Icons.calendar_today,
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                                tooltip: 'Date',
                                onPressed: null,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (pageState.job.selectedDate != null
                                      ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job
                                      .selectedDate)
                                      : 'Not selected'),
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
                              color: Color(ColorConstants.getPeachDark()),
                            ),
                            tooltip: 'Edit',
                            onPressed: null,
                          ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    UserOptionsUtil.showLocationSelectionDialog(context);
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
                                Icons.location_on,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                              tooltip: 'Location',
                              onPressed: null,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                pageState.job.location == null ? 'Not selected' :
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
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                          tooltip: 'Edit',
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 16.0),
                                    height: MediaQuery.of(context).copyWith().size.height / 3,
                                    child: CupertinoDatePicker(
                                      initialDateTime: pageState.job.selectedTime,
                                      onDateTimeChanged: (DateTime time) {
                                        vibrate();
                                        newDateTimeHolder = time;
                                      },
                                      use24hFormat: false,
                                      minuteInterval: 1,
                                      mode: CupertinoDatePickerMode.time,
                                    ),

                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorConstants
                                                .getPrimaryBlack()),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: new Image.asset(
                                              'assets/images/sunset.png',
                                              height: 32.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              (pageState.sunsetTime != null
                                                  ? DateFormat('h:mm a').format(pageState.sunsetTime)
                                                  : ''),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w600,
                                                color: Color(ColorConstants.getPrimaryColor()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          pageState.onNewTimeSelected(newDateTimeHolder);
                                          VibrateUtil.vibrateHeavy();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Done',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorConstants.getPrimaryBlack()),
                                          ),
                                        ),
                                      ),
                                    ],
                                ),
                              ],
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
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                                tooltip: 'Time',
                                onPressed: () {

                                },
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (pageState.job.selectedTime != null
                                      ? DateFormat('h:mm a').format(pageState.job
                                      .selectedTime)
                                      : 'Not selected'),
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
                              pageState.job.selectedTime != null ? Container(
                                padding: EdgeInsets.only(left: 32.0),
                                child: new Image.asset(
                                  'assets/images/sunset.png',
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ) : SizedBox(),
                              pageState.job.selectedTime != null ? Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (pageState.sunsetTime != null
                                      ? DateFormat('h:mm a').format(pageState.sunsetTime)
                                      : ''),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.getPrimaryColor()),
                                  ),
                                ),
                              ) : SizedBox(),
                            ],
                          ),
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(ColorConstants.getPeachDark()),
                            ),
                            tooltip: 'Edit',
                            onPressed: null,
                          ),
                      ],
                    ),
                  ),
                ),

                FlatButton(
                  onPressed: () {
                    UserOptionsUtil.showPricePackageChangeDialog(context);
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
                                  Icons.attach_money,
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                                tooltip: 'Pricing package',
                                onPressed: () {

                                },
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  pageState.job.priceProfile == null ? 'Not selected' :
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
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(ColorConstants.getPeachDark()),
                            ),
                            tooltip: 'Edit',
                            onPressed: () {

                            },
                          ),
                      ],
                    ),
                  ),
                ),
//                FlatButton(
//                  onPressed: null,
//                  child: Container(
//                    height: 48.0,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: <Widget>[
//                            IconButton(
//                              icon: Icon(
//                                Icons.note,
//                                color: Color(ColorConstants.getPeachDark()),
//                              ),
//                              tooltip: 'Notes',
//                              onPressed: () {
//
//                              },
//                            ),
//                            Container(
//                              padding: EdgeInsets.only(left: 8.0),
//                              child: Text(
//                                'Notes:',
//                                textAlign: TextAlign.start,
//                                overflow: TextOverflow.ellipsis,
//                                maxLines: 1,
//                                style: TextStyle(
//                                  fontSize: 16.0,
//                                  fontFamily: 'Raleway',
//                                  fontWeight: FontWeight.w600,
//                                  color: Color(ColorConstants.primary_black),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                        IconButton(
//                          icon: Icon(
//                            Icons.edit,
//                            color: Color(ColorConstants.getPeachDark()),
//                          ),
//                          tooltip: 'Edit',
//                          onPressed: () {
//
//                          },
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.only(left: 72.0, right: 26.0),
//                  child: Text(
//                    pageState.job.notes != null ? pageState.job.notes : '',
//                    textAlign: TextAlign.start,
//                    overflow: TextOverflow.ellipsis,
//                    maxLines: 4,
//                    style: TextStyle(
//                      fontSize: 16.0,
//                      fontFamily: 'Raleway',
//                      fontWeight: FontWeight.w600,
//                      color: Color(ColorConstants.primary_black),
//                    ),
//                  ),
//                ),
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
}
