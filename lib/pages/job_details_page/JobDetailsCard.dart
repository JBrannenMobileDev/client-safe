import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../AppState.dart';
import '../../utils/StringUtils.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobDetailsPageState.dart';
import 'SetupMilesDrivenTrackingBottomSheet.dart';

class JobDetailsCard extends StatefulWidget {
  const JobDetailsCard({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _JobDetailsCard();
  }
}

class _JobDetailsCard extends State<JobDetailsCard> {
  DateTime? newDateTimeHolder;
  bool showMileageError = false;
  bool trackMiles = true;

  void _showSetupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SetupMilesDrivenTrackingBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        newDateTimeHolder = store.state.jobDetailsPageState!.job!.selectedTime;
        trackMiles = store.state.jobDetailsPageState!.job!.shouldTrackMiles!;
      },
      onDidChange: (previous, current) {
        setState(() {
          if(current.job!.location == null || current.job!.selectedDate == null || current.profile == null || !current.profile!.hasDefaultHome()) {
            showMileageError = true;
          } else {
            showMileageError = false;
          }
        });
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 348,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Type:  ${pageState.job?.sessionType?.title}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        height: 36,
                        margin: const EdgeInsets.only(right: 16),
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
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Date:  ${pageState.job?.selectedDate != null
                              ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job!.selectedDate!)
                              : 'Date not selected'}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          color: Color(pageState.job?.selectedDate != null ? ColorConstants.getPrimaryBlack() : ColorConstants.error_red),
                        ),
                      ),
                      Container(
                        height: 36,
                        margin: const EdgeInsets.only(right: 16),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "Price:  ${TextFormatterUtil.formatCurrency(pageState.sessionType?.totalCost.toInt() ?? 0)}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                  (pageState.sessionType?.deposit ?? 0) > 0 ? Container(
                    height: 36,
                    padding: const EdgeInsets.only(left: 16.0),
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Deposit:  ${TextFormatterUtil.formatCurrency(pageState.sessionType?.deposit.toInt() ?? 0)}",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                ) : const SizedBox(),
                Container(
                  height: 36,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "Duration:  ${StringUtils.formatSessionDuration(pageState.sessionType?.durationHours, pageState.sessionType?.durationMinutes)}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 16.0),
                                  height: MediaQuery.of(context).copyWith().size.height / 3,
                                  child: CupertinoDatePicker(
                                    initialDateTime: pageState.job?.selectedTime,
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
                                        Image.asset(
                                          'assets/images/icons/sunset_icon_peach.png',
                                          height: 32.0,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: (pageState.sunsetTime != null
                                                ? DateFormat('h:mm a').format(pageState.sunsetTime!)
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
                                        if(newDateTimeHolder != null) {
                                          pageState.onNewTimeSelected!(newDateTimeHolder!);
                                        }
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
                    margin: const EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Start time:  ${(pageState.job?.selectedTime != null) ? DateFormat('h:mm a').format(pageState.job!.selectedTime!) : 'Not selected'}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          color: Color(pageState.job?.selectedTime != null ? ColorConstants.getPrimaryBlack() : ColorConstants.error_red),
                        ),
                        Container(
                          height: 36,
                          margin: const EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                pageState.mileageTrip == null ? Container(
                  height: 54.0,
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if(showMileageError && trackMiles) {
                            _showSetupSheet(context);
                          } else if(trackMiles) {
                            setState(() {
                              trackMiles = false;
                            });
                            pageState.setMileageAutoTrack!(false);
                          } else {
                            setState(() {
                              trackMiles = true;
                            });
                            pageState.setMileageAutoTrack!(true);
                          }
                        },
                        child: Container(
                          padding: showMileageError && trackMiles ? const EdgeInsets.only(left: 12, right: 12) : const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: showMileageError && trackMiles ? Color(ColorConstants.getBlueLight()).withOpacity(0.25) : Color(ColorConstants.getPrimaryWhite())
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Track miles driven:',
                                    textAlign: TextAlign.center,
                                    color: Color(showMileageError && trackMiles ? ColorConstants.error_red : ColorConstants.getPrimaryBlack()),
                                  ),
                                  showMileageError && trackMiles ? TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: '(Setup required)',
                                    textAlign: TextAlign.center,
                                    color: const Color(ColorConstants.error_red),
                                    isBold: true,
                                  ) : const SizedBox()
                                ],
                              ),
                              showMileageError && trackMiles ? const SizedBox(width: 16) : const SizedBox(),
                              showMileageError && trackMiles ? Image.asset(
                                'assets/images/icons/warning.png',
                                color: const Color(ColorConstants.error_red),
                                height: 26,
                                width: 26,
                              ) : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Device.get().isIos?
                      CupertinoSwitch(
                        trackColor: Color(ColorConstants.getBlueLight()),
                        activeColor: Color(ColorConstants.getBlueDark()),
                        thumbColor: Color(ColorConstants.getPrimaryWhite()),
                        onChanged: (enabled) async {
                          setState(() {
                            trackMiles = enabled;
                          });
                          pageState!.setMileageAutoTrack!(enabled);
                        },
                        value: trackMiles,
                      ) : Switch(
                        activeTrackColor: Color(ColorConstants.getBlueLight()),
                        inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                        activeColor: Color(ColorConstants.getBlueDark()),
                        onChanged: (enabled) async {
                          setState(() {
                            trackMiles = enabled;
                          });
                          pageState!.setMileageAutoTrack!(enabled);
                        },
                        value: trackMiles,
                      )
                    ],
                  ),
                ) : GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(left: 16, right: 0),
                    height: 54,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(ColorConstants.getBlueLight()).withOpacity(0.25)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/directions.png",
                              color: Color(ColorConstants.getBlueDark()),
                              height: 36,
                              width: 36,
                            ),
                            const SizedBox(width: 16),
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: '${TextFormatterUtil.formatLargeNumberOneDecimal(pageState.mileageTrip?.totalMiles ?? 0)} miles driven',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                      ],
                    ),
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
