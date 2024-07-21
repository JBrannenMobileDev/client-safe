import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/ClientSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/DateForm.dart';
import 'package:dandylight/pages/new_job_page/JobTypeSelection.dart';
import 'package:dandylight/pages/new_job_page/LocationSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/TimeSelectionForm.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';

class NewJobPage extends StatefulWidget {
  @override
  _NewJobPageState createState() {
    return _NewJobPageState();
  }
}

class _NewJobPageState extends State<NewJobPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool clientError = false;
  bool sessionTypeError = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) async {
        store.dispatch(ClearStateAction(store.state.newJobPageState));
        if ((await UserPermissionsUtil.getPermissionStatus(
                Permission.locationWhenInUse))
            .isGranted) {
          store.dispatch(
              SetLastKnowInitialPosition(store.state.newJobPageState));
        }
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => new CupertinoAlertDialog(
              title: new Text('Are you sure?'),
              content:
                  new Text('All unsaved information entered will be lost.'),
              actions: <Widget>[
                TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          );
          return shouldPop!;
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                      pinned: true,
                      centerTitle: true,
                      surfaceTintColor: Colors.transparent,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'New Booking',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      leading: GestureDetector(
                        child: const Icon(Icons.close, color: Colors.black),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          buildOptionWidget(
                              'CLIENT*',
                              'Who is this booking for?',
                              pageState.selectedClient != null ? (pageState.selectedClient?.firstName ?? 'Client name') : 'Add new contact',
                              (){},
                              clientError
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   width: MediaQuery.of(context).size.width,
                          //   child: TextDandyLight(
                          //     type: TextDandyLight.SMALL_TEXT,
                          //     text: 'or',
                          //     color: Color(ColorConstants.getPrimaryBlack()),
                          //   ),
                          // ),
                          pageState.selectedClient == null ? GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              alignment: Alignment.center,
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: clientError ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                                    width: clientError ? 2 : 0
                                ),
                                color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'From Dandylight contacts',
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) : const SizedBox(),
                          buildOptionWidget(
                              'SESSION TYPE*',
                              null,
                              pageState.selectedSessionType != null ? (pageState.selectedSessionType?.title ?? 'N/A') : 'Select session type',
                                  (){},
                              sessionTypeError
                          ),
                          buildOptionWidget(
                              'SESSION LOCATION',
                              null,
                              pageState.selectedLocation != null ? (pageState.selectedLocation?.locationName ?? 'N/A') : 'Select a location',
                                  (){},
                              false
                          ),
                          buildOptionWidget(
                              'SESSION DATE',
                              null,
                              pageState.selectedDate != null ? (TextFormatterUtil.formatDateStandard(pageState.selectedDate!)) : 'Select a date',
                                  (){},
                              false
                          ),
                          buildOptionWidget(
                              'SESSION START TIME',
                              null,
                              pageState.selectedStartTime != null ? (DateFormat('h:mm a').format(pageState.selectedStartTime!)) : 'Select a type',
                                  (){},
                              false
                          ),
                          // ClientSelectionForm(),
                          // JobTypeSelection(),
                          // LocationSelectionForm(),
                          // DateForm(),
                          // TimeSelectionForm(),
                        ]
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionWidget(String title, String? message, String buttonMessage, Function action, bool errorState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, top: 24),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: title,
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        message != null ? Container(
          margin: const EdgeInsets.only(left: 8, top: 0),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: message,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ) : const SizedBox(),
        GestureDetector(
          onTap: () {
            action();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            alignment: Alignment.center,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: errorState ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                  width: errorState ? 2 : 0
              ),
              color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: buttonMessage,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void showSuccessAnimation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
