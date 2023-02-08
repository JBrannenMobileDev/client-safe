import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/TextDandyLight.dart';

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
            height: 448.0,
            width: double.maxFinite,
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Job Info',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
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
                              width: 58.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Type:',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.job.type.title,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/edit_icon_peach.png'),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
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
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: GestureDetector(
                                  onTap: () {

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 12.0),
                                    height: 32.0,
                                    width: 32.0,
                                    child: Image.asset('assets/images/icons/calendar_icon_peach.png', color: Color(pageState.job.selectedDate != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: (pageState.job.selectedDate != null
                                      ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job.selectedDate)
                                      : 'Date not selected'),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: Color(pageState.job.selectedDate != null ? ColorConstants.primary_black : ColorConstants.error_red),
                                ),
                              ),
                            ],
                          ),
                        Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/edit_icon_peach.png'),
                          ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
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
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Cancel',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        color: Color(ColorConstants
                                            .getPrimaryBlack()),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: new Image.asset(
                                            'assets/images/icons/sunset_icon_peach.png',
                                            height: 32.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: (pageState.sunsetTime != null
                                                ? DateFormat('h:mm a').format(pageState.sunsetTime)
                                                : ''),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            color: Color(ColorConstants.getPeachDark()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {
                                        pageState.onNewTimeSelected(newDateTimeHolder);
                                        VibrateUtil.vibrateHeavy();
                                        Navigator.of(context).pop();
                                      },
                                      child: TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Done',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        color: Color(ColorConstants.getPrimaryBlack()),
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
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12.0),
                                  height: 32.0,
                                  width: 32.0,
                                  child: Image.asset('assets/images/icons/clock_icon_peach.png', color: Color(pageState.job.selectedTime != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: (pageState.job.selectedTime != null ? DateFormat('h:mm a').format(pageState.job.selectedTime)
                                    : 'Start time not selected'),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(pageState.job.selectedTime != null ? ColorConstants.primary_black : ColorConstants.error_red),
                              ),
                            ),
                            pageState.job.selectedTime != null && pageState.sunsetTime != null ? Container(
                              padding: EdgeInsets.only(left: 32.0),
                              child: new Image.asset(
                                'assets/images/icons/sunset_icon_peach.png',
                                height: 32.0,
                                fit: BoxFit.cover,
                              ),
                            ) : SizedBox(),
                            pageState.job.selectedTime != null && pageState.job.selectedDate != null ? Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: (pageState.sunsetTime != null
                                    ? DateFormat('h:mm a').format(pageState.sunsetTime)
                                    : ''),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                            ) : SizedBox(),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 12.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/edit_icon_peach.png', color: Color(pageState.job.selectedTime != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
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
                                    initialDateTime: pageState.job.selectedEndTime,
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
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Cancel',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        color: Color(ColorConstants
                                            .getPrimaryBlack()),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: new Image.asset(
                                            'assets/images/icons/sunset_icon_peach.png',
                                            height: 32.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: (pageState.sunsetTime != null
                                                ? DateFormat('h:mm a').format(pageState.sunsetTime)
                                                : ''),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            color: Color(ColorConstants.getPeachDark()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      style: Styles.getButtonStyle(),
                                      onPressed: () {
                                        pageState.onNewEndTimeSelected(newDateTimeHolder);
                                        VibrateUtil.vibrateHeavy();
                                        Navigator.of(context).pop();
                                      },
                                      child: TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Done',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        color: Color(ColorConstants.getPrimaryBlack()),
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
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12.0),
                                  height: 32.0,
                                  width: 32.0,
                                  child: Image.asset('assets/images/icons/clock_icon_peach.png', color: Color(pageState.job.selectedEndTime != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: (pageState.job.selectedEndTime != null ? DateFormat('h:mm a').format(pageState.job.selectedEndTime) + ' - End time' : 'End time not selected'),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(pageState.job.selectedEndTime != null ? ColorConstants.primary_black : ColorConstants.error_red),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 12.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/edit_icon_peach.png', color: Color(pageState.job.selectedEndTime != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
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
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12.0),
                                  height: 32.0,
                                  width: 32.0,
                                  child: Image.asset('assets/images/icons/location_icon_peach.png', color: Color(pageState.job.location != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.job.location == null ? 'Location not selected' :
                                pageState.job.location.locationName,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(pageState.job.location != null ? ColorConstants.primary_black : ColorConstants.error_red),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            pageState.job.location != null ? IconButton(
                              iconSize: 26.0,
                              icon: Icon(Device.get().isIos ? CupertinoIcons.share_solid : Icons.share),
                              color: Color(ColorConstants.getPeachDark()),
                              tooltip: 'Share',
                              onPressed: () {
                                Share.share('Hi ${pageState.job.clientName.split(' ')[0]}, here are the driving directions to the shoot location. \nLocation: ${pageState.selectedLocation.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${pageState.selectedLocation.latitude},${pageState.selectedLocation.longitude}');
                              },
                            ) : SizedBox(),
                            Container(
                              margin: EdgeInsets.only(left: 8.0, right: 12.0),
                              height: 24.0,
                              width: 24.0,
                              child: Image.asset('assets/images/icons/edit_icon_peach.png', color: Color(pageState.job.location != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
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
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: GestureDetector(
                                  onTap: () {

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 12.0),
                                    height: 32.0,
                                    width: 32.0,
                                    child: Image.asset('assets/images/icons/price_package_icon.png', color: Color(pageState.job.priceProfile != null ? ColorConstants.getPeachDark() : ColorConstants.error_red),),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 158,
                                padding: EdgeInsets.only(left: 8.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.job.priceProfile == null ? 'Price package not selected' :
                                  TextFormatterUtil.formatDecimalCurrency(pageState.job.priceProfile.flatRate) + ' ' + pageState.job.priceProfile.profileName,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: Color(pageState.job.priceProfile != null ? ColorConstants.primary_black : ColorConstants.error_red),
                                ),
                              ),
                            ],
                       ),
                        Container(
                          margin: EdgeInsets.only(right: 12.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/edit_icon_peach.png', color: Color(pageState.job.priceProfile != null ? ColorConstants.getPeachDark() : ColorConstants.error_red)),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    UserOptionsUtil.showAddOnCostSelectionDialog(context);
                  },
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Container(
                                  margin: EdgeInsets.only(right: 12.0),
                                  height: 32.0,
                                  width: 32.0,
                                  child: Image.asset('assets/images/icons/deposit_icon_peach.png'),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: (pageState.job.addOnCost != null ? TextFormatterUtil.formatDecimalCurrency(pageState.job.addOnCost) : '\$0.00') + ' (Add-on cost)',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: null,
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/edit_icon_peach.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    UserOptionsUtil.showTipChangeDialog(context);
                  },
                  child: Container(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Container(
                                margin: EdgeInsets.only(right: 12.0),
                                height: 32.0,
                                width: 32.0,
                                child: Image.asset('assets/images/icons/deposit_icon_peach.png'),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.job.tipAmount == null ? '\$0.00 (tip)' :
                                (pageState.job.tipAmount != null ? TextFormatterUtil.formatDecimalCurrency(pageState.job.tipAmount.toDouble()) : '\$0.00') + ' (tip)',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: null,
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/edit_icon_peach.png'),
                          ),
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
