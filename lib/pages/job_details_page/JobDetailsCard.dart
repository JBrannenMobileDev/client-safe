import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobDetailsPageState.dart';

class JobDetailsCard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsCard();
  }
}

class _JobDetailsCard extends State<JobDetailsCard> {
  DateTime newDateTimeHolder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        newDateTimeHolder = store.state.jobDetailsPageState.job.selectedTime;
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 266,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Details',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UserOptionsUtil.showJobTypeChangeDialog(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Type:  " + pageState.job.type.title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        height: 36,
                        margin: EdgeInsets.only(right: 16),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UserOptionsUtil.showPricePackageChangeDialog(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: pageState.job.priceProfile == null ? 'Price package not selected' :
                          'Package:  ' + pageState.job.priceProfile.profileName,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        height: 36,
                        margin: EdgeInsets.only(right: 16),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UserOptionsUtil.showDateSelectionCalendarDialog(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Date:  " + (pageState.job.selectedDate != null
                              ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job.selectedDate)
                              : 'Date not selected'),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          color: Color(pageState.job.selectedDate != null ? ColorConstants.getPrimaryBlack() : ColorConstants.error_red),
                        ),
                      ),
                      Container(
                        height: 36,
                        margin: EdgeInsets.only(right: 16),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
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
                            margin: EdgeInsets.only(right: 8),
                            height: 78,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Start',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextDandyLight(
                                        type: TextDandyLight.LARGE_TEXT,
                                        text: (pageState.job.selectedTime != null ? DateFormat('h:mm a').format(pageState.job.selectedTime) : 'Not selected'),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        color: Color(pageState.job.selectedTime != null ? ColorConstants.getPrimaryBlack() : ColorConstants.error_red),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
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
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            height: 78,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'End',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextDandyLight(
                                        type: TextDandyLight.LARGE_TEXT,
                                        text: (pageState.job.selectedEndTime != null ? DateFormat('h:mm a').format(pageState.job.selectedEndTime) : 'Not Selected'),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        color: Color(pageState.job.selectedEndTime != null ? ColorConstants.getPrimaryBlack() : ColorConstants.error_red),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}
