import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../sunset_weather_page/SunsetWeatherPage.dart';

class TimeSelectionForm extends StatefulWidget {
  @override
  _TimeSelectionFormState createState() {
    return _TimeSelectionFormState();
  }
}

class _TimeSelectionFormState extends State<TimeSelectionForm> with AutomaticKeepAliveClientMixin{
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchTimeOfSunsetAction(store.state.newJobPageState));
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: const EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: "Select a start and end time for this job.",
              textAlign: TextAlign.center,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
            pageState.sunsetDateTime != null ? Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      pageState.onSunsetWeatherSelected!();
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => const SunsetWeatherPage()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        color: Color(ColorConstants.getPeachDark())
                      ),
                        child: Image.asset(
                          'assets/images/icons/sunset_icon_peach.png',
                          height: 36.0,
                          fit: BoxFit.cover,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Sunset is at " +
                          (pageState.sunsetDateTime != null
                              ? DateFormat('h:mm a').format(pageState.sunsetDateTime!)
                              : ""),
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  )
                ],
              ),
            ) : const SizedBox(height: 48.0,),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                showStartTimeSelectionSheet(pageState);
              },
              child: Container(
                alignment: Alignment.center,
                width: 250,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 48.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                    color: Color(ColorConstants.getPeachDark())),
                child:
                    Container(
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: pageState.selectedStartTime != null ? 'Start - ' + DateFormat('h:mm a').format(pageState.selectedStartTime!) : 'Start time',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 32.0),
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  showEndTimeSelectionSheet(pageState);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 48.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.0),
                      color: Color(ColorConstants.getPeachDark())),
                  child: Container(
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: pageState.selectedEndTime != null ? 'End - ' + DateFormat('h:mm a').format(pageState.selectedEndTime!) : 'End time',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          color: Color(
                              ColorConstants.getPrimaryWhite()),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showStartTimeSelectionSheet(NewJobPageState pageState) {
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
                    initialDateTime: pageState.initialTimeSelectorTime,
                    onDateTimeChanged: (DateTime time) {
                      vibrate();
                      startTime = time;
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
                    pageState.sunsetDateTime != null ? Row(
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
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: DateFormat('h:mm a').format(pageState.sunsetDateTime!),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        startTime ??= pageState.initialTimeSelectorTime;
                        pageState.onStartTimeSelected!(startTime!);
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
  }

  void showEndTimeSelectionSheet(NewJobPageState pageState) {
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
                    initialDateTime: getEndInitialEndTime(pageState.initialTimeSelectorTime),
                    onDateTimeChanged: (DateTime time) {
                      vibrate();
                      endTime = time;
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
                    pageState.sunsetDateTime != null ? Row(
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
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: DateFormat('h:mm a').format(pageState.sunsetDateTime!),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        if(endTime == null) {
                          DateTime? endTimeLocal = pageState.initialTimeSelectorTime;
                          if(endTimeLocal != null) {
                            endTimeLocal.add(const Duration(hours: 1));
                            pageState.onEndTimeSelected!(endTimeLocal);
                          }
                        } else {
                          pageState.onEndTimeSelected!(endTime!);
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
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }

  @override
  bool get wantKeepAlive => true;

  getEndInitialEndTime(DateTime? initialTimeSelectorTime) {
    DateTime? endTimeLocal = initialTimeSelectorTime;
    if(endTimeLocal != null) {
      endTimeLocal.add(const Duration(hours: 1));
      return endTimeLocal;
    } else {
      return DateTime.now();
    }
  }
}
