import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/ImportDeviceContactBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/SelectDateBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/SelectLeadSourceBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/SelectLocationBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/SelectPreviousClientBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/SelectSessionTypeBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/SelectStartTimeBottomSheet.dart';
import 'package:dandylight/pages/new_job_page/SessionTypeIncompleteWarningBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/Client.dart';
import '../../models/SessionType.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/Shadows.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import '../../widgets/TextFieldSimple.dart';

class NewJobPage extends StatefulWidget {
  final Client? client;

  NewJobPage({this.client});

  @override
  _NewJobPageState createState() {
    return _NewJobPageState(client);
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
  final Client? client;
  bool isTyping = false;

  _NewJobPageState(this.client);

  bool clientError = false;
  bool sessionTypeError = false;
  bool firstNameError = false;
  bool leadSourceError = false;

  @override
  void initState() {
    super.initState();
    firstNameFocusNode.addListener(() {
      setIsTyping(firstNameFocusNode.hasFocus);
    });
    lastNameFocusNode.addListener(() {
      setIsTyping(lastNameFocusNode.hasFocus);
    });
    phoneFocusNode.addListener(() {
      setIsTyping(phoneFocusNode.hasFocus);
    });
    emailFocusNode.addListener(() {
      setIsTyping(emailFocusNode.hasFocus);
    });
    instagramUrlFocusNode.addListener(() {
      setIsTyping(instagramUrlFocusNode.hasFocus);
    });
  }

  void setIsTyping(bool hasFocus) {
    isTyping = hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) async {
        store.dispatch(ClearStateAction(store.state.newJobPageState));
        if ((await UserPermissionsUtil.getPermissionStatus(Permission.locationWhenInUse)).isGranted) {
          store.dispatch(
              SetLastKnowInitialPosition(store.state.newJobPageState)
          );
        }
        if(client != null) {
          store.dispatch(LoadNewJobWithClientAction(store.state.newJobPageState, client));
        }
        store.dispatch(FetchAllAction(store.state.newJobPageState));
      },
      onDidChange: (previous, current) {
        if(current.deviceContactFirstName != firstNameController.text && current.deviceContactFirstName != (previous?.deviceContactFirstName ?? '')) firstNameController.text = current.deviceContactFirstName ?? '';
        if(current.deviceContactLastName != lastNameController.text && current.deviceContactLastName != (previous?.deviceContactLastName ?? '')) lastNameController.text = current.deviceContactLastName ?? '';
        if(current.deviceContactPhone != phoneController.text && current.deviceContactPhone != (previous?.deviceContactPhone ?? '')) phoneController.text = current.deviceContactPhone ?? '';
        if(current.deviceContactEmail != emailController.text && current.deviceContactEmail != (previous?.deviceContactEmail ?? '')) emailController.text = current.deviceContactEmail ?? '';
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
                                color: Color(ColorConstants.getPrimaryGreyDark()),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: pageState.selectedClient != null ? '${pageState.selectedClient?.firstName ?? 'Client name'} ${pageState.selectedClient?.lastName ?? 'Last name'}' : 'Select previous client',
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          pageState.selectedClient == null ? Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 8, bottom: 4),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'OR',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ) : const SizedBox(),
                          pageState.selectedClient == null ? GestureDetector(
                            onTap: () {
                              UserPermissionsUtil.showPermissionRequest(
                                permission: Permission.contacts,
                                context: context,
                                callOnGranted: () {
                                  _showSelectDeviceContactBottomSheet(context);
                                },
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
                                color: Color(ColorConstants.getPrimaryGreyDark()),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    child: TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'Import device contact',
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) : const SizedBox(),
                          pageState.selectedClient == null ? Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 16),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'OR',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ) : const SizedBox(),
                          pageState.selectedClient == null ? clientInfoItems(pageState) : const SizedBox(),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 16, bottom: 8),
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
                              (){
                                _showSessionSelectionBottomSheet(context);
                              },
                              sessionTypeError
                          ),
                          buildOptionWidget(
                              'SESSION LOCATION',
                              null,
                              pageState.selectedLocation != null ? (pageState.selectedLocation?.locationName ?? 'N/A') : 'Select a location',
                              (){
                                _showLocationSelectionBottomSheet(context);
                              },
                              false
                          ),
                          buildOptionWidget(
                              'SESSION DATE',
                              null,
                              pageState.selectedDate != null ? (TextFormatterUtil.formatDateStandard(pageState.selectedDate!)) : 'Select a date',
                              (){
                                _showDateSelectionBottomSheet(context);
                              },
                              false
                          ),
                          buildOptionWidget(
                              'SESSION START TIME',
                              null,
                              pageState.selectedStartTime != null ? (DateFormat('h:mm a').format(pageState.selectedStartTime!)) : 'Select a start time',
                              (){
                                _showStartTimeSelectionBottomSheet(context);
                              },
                              false
                          ),
                          const SizedBox(height: 164)
                        ]
                      )
                    ),
                  ],
                ),
                !isTyping ? GestureDetector(
                  onTap: () {
                    if(pageState.selectedSessionType != null && (pageState.selectedSessionType?.totalCost ?? 0) == 0) {
                      showSessionTypeErrorBottomSheet(context, pageState.selectedSessionType!);
                    } else {
                      setState(() {
                        if((pageState.leadSource?.isEmpty ?? true) && pageState.selectedClient == null) {
                          leadSourceError = true;
                        } else {
                          leadSourceError = false;
                        }
                        if(pageState.selectedSessionType == null) {
                          sessionTypeError = true;
                        } else {
                          sessionTypeError = false;
                        }
                        if(pageState.selectedClient == null && (pageState.deviceContactFirstName?.isEmpty ?? true)) {
                          firstNameError = true;
                          clientError = true;
                        } else {
                          firstNameError = false;
                          clientError = false;
                        }
                      });
                      if(!clientError && !firstNameError && !leadSourceError && !sessionTypeError) {
                        pageState.onSavePressed!();
                        showSuccessAnimation();
                      } else {
                        if(clientError) DandyToastUtil.showErrorToast('Missing client info');
                        else if(firstNameError) DandyToastUtil.showErrorToast('Missing client first name');
                        else if(leadSourceError) DandyToastUtil.showErrorToast('Missing client lead source');
                        else if(sessionTypeError) DandyToastUtil.showErrorToast('Missing session type');
                      }
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
                ) : const SizedBox(),
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
            margin: const EdgeInsets.only(top: 0, bottom: 16),
            alignment: Alignment.center,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: errorState ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyDark()),
                  width: errorState ? 2 : 0
              ),
              color: Color(ColorConstants.getPrimaryGreyDark()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: buttonMessage,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void showSessionTypeErrorBottomSheet(BuildContext context, SessionType sessionType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SessionTypeIncompleteWarningBottomSheet(sessionType: sessionType);
      },
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

  void _showLeadSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectLeadSourceBottomSheet();
      },
    );
  }

  void _showSessionSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectSessionTypeBottomSheet();
      },
    );
  }

  void _showLocationSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectLocationBottomSheet();
      },
    );
  }

  void _showDateSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectDateBottomSheet();
      },
    );
  }

  void _showStartTimeSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectStartTimeBottomSheet();
      },
    );
  }

  void onTimeSelected() {

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
    NavigationUtil.onJobTapped(context, false, "");
  }

  Widget clientInfoItems(NewJobPageState pageState) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 24),
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
          onTextInputChanged: pageState.onDeviceContactFirstNameChanged!,
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
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          child: TextDandyLight(
            type: TextDandyLight.EXTRA_SMALL_TEXT,
            text: 'LEAD SOURCE*',
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, top: 0),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: 'How did ${(pageState.deviceContactFirstName?.isNotEmpty ?? false) ? pageState.deviceContactFirstName : 'this client'} hear about your business?',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
        GestureDetector(
          onTap: () {
            _showLeadSelectionBottomSheet(context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            alignment: Alignment.center,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: leadSourceError ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyDark()),
                  width: leadSourceError ? 2 : 0
              ),
              color: Color(ColorConstants.getPrimaryGreyDark()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: getLeadSourceName(pageState),
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );

  String getLeadSourceName(NewJobPageState pageState) {
    String result = '';
    if(pageState.leadSource?.isNotEmpty ?? false) {
      if(pageState.leadSource == 'Other') {
        result = pageState.customLeadSourceName ?? '';
      } else {
        result = pageState.leadSource ?? '';
      }
    } else {
      result = 'Select a source';
    }
    return result;
  }
}
