import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/ClientSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/DateForm.dart';
import 'package:dandylight/pages/new_job_page/ImportDeviceContactBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/JobTypeSelection.dart';
import 'package:dandylight/pages/new_job_page/LocationSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/SelectPreviousClientBottomSheet.dart';
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

import '../../utils/Shadows.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import '../../widgets/TextFieldSimple.dart';

class NewJobPage extends StatefulWidget {
  @override
  _NewJobPageState createState() {
    return _NewJobPageState();
  }
}

class _NewJobPageState extends State<NewJobPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final instagramUrlController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final instagramUrlFocusNode = FocusNode();


  bool clientError = false;
  bool sessionTypeError = false;
  bool firstNameError = false;

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
                        text: 'New Job',
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
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 8, top: 16),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Who is this booking for?',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showSelectClientBottomSheet(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 0),
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
                                      text: pageState.selectedClient != null ? '${pageState.selectedClient?.firstName ?? 'Client name'} ${pageState.selectedClient?.lastName ?? 'Last name'}' : 'Select previous client',
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
                          ),
                          pageState.selectedClient == null ? Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 4),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'or',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ) : const SizedBox(),
                          pageState.selectedClient == null ? GestureDetector(
                            onTap: () {
                              _showSelectDeviceContactBottomSheet(context);
                              UserPermissionsUtil.showPermissionRequest(
                                permission: Permission.contacts,
                                context: context,
                                callOnGranted: (){},
                              );
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
                                      text: 'Import device contact',
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
                          pageState.selectedClient == null ? clientInfoItems(pageState) : const SizedBox(),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 32, bottom: 8),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Session Details',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
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
                              pageState.selectedStartTime != null ? (DateFormat('h:mm a').format(pageState.selectedStartTime!)) : 'Select a start time',
                                  (){},
                              false
                          ),
                          const SizedBox(height: 164)
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
                GestureDetector(
                  onTap: () {
                    if(pageState.saveButtonEnabled ?? false) {
                      pageState.onSavePressed!();
                      showSuccessAnimation();
                    } else {
                      setState(() {
                        // if(nameController.text.isEmpty) nameError = true;
                        // if(hoursController.text.isEmpty && minController.text.isEmpty) durationError = true;
                        // if(totalCostTextController.text.isEmpty) priceError = true;
                        // if(!(pageState.stagesComplete ?? false)) stagesError = true;
                        // if(!(pageState.remindersComplete ?? false)) remindersError = true;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width/2,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Color(ColorConstants.getPeachDark()),
                      boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Save',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
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
          margin: const EdgeInsets.only(left: 8, top: 0),
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
            margin: const EdgeInsets.only(top: 8, bottom: 24),
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

  void _showSelectClientBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectPreviousClientBottomSheet();
      },
    );
  }

  void _showSelectDeviceContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const ImportDeviceContactBottomSheet();
      },
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

  Widget clientInfoItems(NewJobPageState pageState) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 48),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: 'Client Info',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: 'FIRST NAME*',
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        TextFieldSimple(
          controller: firstNameController,
          hintText: 'First name',
          inputType: TextInputType.name,
          focusNode: firstNameFocusNode,
          hasError: firstNameError,
          onFocusAction: (){
            FocusScope.of(context).requestFocus(lastNameFocusNode);
          },
          onTextInputChanged: pageState.onClientFirstNameTextChanged!,
          keyboardAction: TextInputAction.next,
          capitalization: TextCapitalization.words,
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: 'LAST NAME',
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        TextFieldSimple(
          controller: lastNameController,
          hintText: 'Last name',
          inputType: TextInputType.name,
          focusNode: lastNameFocusNode,
          hasError: false,
          onFocusAction: (){
            FocusScope.of(context).requestFocus(phoneFocusNode);
          },
          onTextInputChanged: pageState.onClientLastNameTextChanged!,
          keyboardAction: TextInputAction.next,
          capitalization: TextCapitalization.words,
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: 'PHONE NUMBER',
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        TextFieldSimple(
          controller: phoneController,
          hintText: '(888) 888-8888',
          inputType: TextInputType.phone,
          focusNode: phoneFocusNode,
          hasError: false,
          onFocusAction: (){
            FocusScope.of(context).requestFocus(emailFocusNode);
          },
          onTextInputChanged: pageState.onClientPhoneTextChanged!,
          keyboardAction: TextInputAction.next,
          capitalization: TextCapitalization.none,
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: 'EMAIL ADDRESS',
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        TextFieldSimple(
          controller: emailController,
          hintText: 'exampleemail@gmail.com',
          inputType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
          hasError: false,
          onFocusAction: (){
            FocusScope.of(context).requestFocus(instagramUrlFocusNode);
          },
          onTextInputChanged: pageState.onClientEmailTextChanged!,
          keyboardAction: TextInputAction.next,
          capitalization: TextCapitalization.none,
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: 'INSTAGRAM PROFILE URL',
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        TextFieldSimple(
          controller: instagramUrlController,
          hintText: 'https://instagram.com/profileName...',
          inputType: TextInputType.url,
          focusNode: instagramUrlFocusNode,
          hasError: false,
          onFocusAction: (){
            FocusScope.of(context).requestFocus(instagramUrlFocusNode);
          },
          onTextInputChanged: pageState.onClientInstagramUrlTextChanged!,
          keyboardAction: TextInputAction.next,
          capitalization: TextCapitalization.none,
        )
      ],
    );
}
