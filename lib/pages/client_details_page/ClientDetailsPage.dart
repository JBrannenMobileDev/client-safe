import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/client_details_page/ClientJobItem.dart';
import 'package:dandylight/pages/new_job_page/NewJobPage.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/ImageUtil.dart';
import '../../utils/styles/Styles.dart';
import '../new_contact_pages/NewContactPageState.dart';
import '../new_contact_pages/NewContactTextField.dart';

class ClientDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientDetailsPage();
  }
}

class _ClientDetailsPage extends State<ClientDetailsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final customLeadController = TextEditingController();
  final FocusNode _customLeadFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<String> leadSourceIconsWhite = ImageUtil.leadSourceIconsWhite;
    List<String> leadSourceIconsPeach = ImageUtil.leadSourceIconsPeach;
    return StoreConnector<AppState, ClientDetailsPageState>(
      onInit: (store) {
        customLeadController.value = customLeadController.value.copyWith(text:store.state.clientDetailsPageState.customLeadSourceName);
      },
      onWillChange: (statePrevious, stateNew) {
        customLeadController.value = customLeadController.value.copyWith(text:stateNew.customLeadSourceName);
      },
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.grey),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  brightness: Brightness.light,
                  backgroundColor: Color(ColorConstants.grey),
                  expandedHeight: 264.0,
                  pinned: true,
                  floating: false,
                  forceElevated: false,
                  centerTitle: true,
                  title: Text(
                    pageState.client?.getClientFullName() ?? "",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: const Color(ColorConstants.primary_black),
                    ),
                  ),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pageState.onEditClientClicked(pageState.client);
                        UserOptionsUtil.showNewContactDialog(context, false);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset(
                            'assets/images/icons/edit_icon_peach.png'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _ackAlert(context, pageState);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset(
                            'assets/images/icons/trash_icon_peach.png'),
                      ),
                    ),
                  ],
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    color: Color(ColorConstants.getPrimaryColor()),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(0),
                              bottom: Radius.circular(32)),
                          color: Color(ColorConstants.getPrimaryWhite())
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 96.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 3,
                            child: Image.asset(
                              'assets/images/icons/profile_icon.png',
                              color: Color(ColorConstants.getPrimaryColor()),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (pageState.client.phone != null &&
                                      pageState.client.phone.length > 0) {
                                    onCallPressed(pageState.client.phone);
                                  } else {
                                    DandyToastUtil.showErrorToast(
                                        'No phone number saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset(
                                      'assets/images/icons/phonecall_icon_white.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (pageState.client.phone != null &&
                                      pageState.client.phone.length > 0) {
                                    onSMSPressed(pageState.client.phone);
                                  } else {
                                    DandyToastUtil.showErrorToast(
                                        'No phone number saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset(
                                      'assets/images/icons/sms_icon_white.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (pageState.client.email != null &&
                                      pageState.client.email.length > 0) {
                                    onEmailPressed(pageState.client.email);
                                  } else {
                                    DandyToastUtil.showErrorToast(
                                        'No email saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset(
                                      'assets/images/icons/email_icon_white.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (pageState.client.instagramProfileUrl !=
                                      null &&
                                      pageState.client.instagramProfileUrl
                                          .length > 0) {
                                    pageState.onInstagramSelected();
                                  } else {
                                    DandyToastUtil.showErrorToast(
                                        'No Instagram URL saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset(
                                      'assets/images/icons/instagram_icon_white.png'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        height: 104,
                        margin: EdgeInsets.only(
                            left: 16, top: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 24.0, bottom: 8.0, right: 24),
                              child: Text(
                                'Job History',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 24, right: 18.0),
                                  height: 38.0,
                                  width: 38.0,
                                  child: Image.asset(
                                    'assets/images/icons/briefcase_icon_white.png',
                                    color: Color(ColorConstants.peach_dark),),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 4.0, top: 4.0),
                                        child: Text(
                                          (pageState.clientJobs != null &&
                                              pageState.clientJobs.length > 0)
                                              ? pageState.clientJobs.length
                                              .toString() + ' Jobs'
                                              : '0 Jobs',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w600,
                                            color: Color(
                                                ColorConstants.primary_black),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Color(ColorConstants
                                              .getPrimaryBackgroundGrey()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 16),
                        height: 135,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 24.0),
                              child: Text(
                                'Notes',
                                textAlign: TextAlign.start,
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
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
                            builder: (context) {
                              return StoreConnector<
                                  AppState,
                                  ClientDetailsPageState>(
                                converter: (store) =>
                                    ClientDetailsPageState.fromStore(store),
                                builder: (BuildContext context,
                                    ClientDetailsPageState modalPageState) =>
                                    Container(
                                      height: 500,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16.0)),
                                          color: Color(
                                              ColorConstants.getPrimaryWhite())
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 16.0,
                                            right: 16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(top: 4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontFamily: 'simple',
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(ColorConstants.primary_black),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      pageState.onSaveLeadSourceSelected();
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      'Save',
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontFamily: 'simple',
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(ColorConstants.primary_black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 0, bottom: 32.0),
                                              child: Text(
                                                'Select a lead source',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontFamily: 'simple',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(ColorConstants
                                                      .primary_black),
                                                ),
                                              ),
                                            ),
                                            GridView.builder(
                                                shrinkWrap: true,
                                                itemCount: 8,
                                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                    childAspectRatio: 0.8),
                                                itemBuilder: (
                                                    BuildContext context,
                                                    int index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      modalPageState.onLeadSourceSelected(leadSourceIconsWhite.elementAt(index));
                                                    },
                                                    child:
                                                    Column(
                                                      children: <Widget>[
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: <Widget>[
                                                            modalPageState.leadSource != null && getIconPosition(modalPageState, leadSourceIconsWhite) == index
                                                                ? new Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  bottom: 8.0),
                                                              height: 46.0,
                                                              width: 46.0,
                                                              decoration: new BoxDecoration(
                                                                color: Color(
                                                                    ColorConstants
                                                                        .getBlueLight()),
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    12.0),
                                                              ),
                                                            )
                                                                : SizedBox(
                                                              height: 54.0,
                                                              width: 46.0,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  bottom: 8.0),
                                                              height: 36.0,
                                                              width: 36.0,
                                                      child: Image.asset(leadSourceIconsPeach.elementAt(index), color: Color(modalPageState.leadSource != null && getIconPosition(modalPageState, leadSourceIconsWhite) == index ? ColorConstants.getPrimaryWhite() : ColorConstants.getPeachDark()),),
                                                    ),
                                                  ],
                                                ),
                                                        Text(
                                                          ImageUtil
                                                              .getLeadSourceText(
                                                              leadSourceIconsWhite
                                                                  .elementAt(
                                                                  index)),
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily: 'simple',
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            color: Color(
                                                                ColorConstants
                                                                    .primary_black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ),
                                            Container(
                                              height: 66.0,
                                              width: 275,
                                              child: modalPageState.leadSource ==
                                                  'assets/images/icons/email_icon_white.png'
                                                  ? NewContactTextField(
                                                  customLeadController,
                                                  "Custom Name",
                                                  TextInputType.text,
                                                  66.0,
                                                  modalPageState.onCustomLeadSourceTextChanged,
                                                  NewContactPageState.NO_ERROR,
                                                  TextInputAction.done,
                                                  _customLeadFocusNode,
                                                  onAction,
                                                  TextCapitalization.words,
                                                  null,
                                                  true)
                                                  : SizedBox(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 16, top: 0, right: 16, bottom: 16),
                          height: 104,
                          decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    left: 24.0, bottom: 8.0, right: 24),
                                child: Text(
                                  'Lead Source',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.primary_black),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 24, right: 18.0),
                                    height: 38.0,
                                    width: 38.0,
                                    child: Image.asset(
                                      pageState.client.leadSource,
                                      color: Color(ColorConstants.peach_dark),),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 4.0, top: 4.0),
                                          child: Text(
                                            _getLeadSourceName(pageState),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(
                                                  ColorConstants.primary_black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 16),
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 128),
                        height: 104,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 24.0, bottom: 8.0, right: 24),
                              child: Text(
                                'Important Dates',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 24, right: 18.0),
                                  height: 38.0,
                                  width: 38.0,
                                  child: Image.asset(
                                    'assets/images/icons/calendar_icon_peach.png',
                                    color: Color(ColorConstants.peach_dark),),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 4.0, top: 4.0),
                                        child: Text(
                                          pageState.client.importantDates.length
                                              .toString() + ' Dates',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'simple',
                                            fontWeight: FontWeight.w600,
                                            color: Color(
                                                ColorConstants.primary_black),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Color(ColorConstants
                                              .getPrimaryBackgroundGrey()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );

    void _showNewJobDialog(ClientDetailsPageState pageState) {
      pageState.onStartNewJobClicked(pageState.client);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return NewJobPage();
        },
      );
    }
  }

  Future<void> _ackAlert(BuildContext context,
      ClientDetailsPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device
            .get()
            .isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This contact will be gone for good!'),
          actions: <Widget>[
            new TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteClientClicked();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This contact will be gone for good!'),
          actions: <Widget>[
            new TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteClientClicked();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  String _getLeadSourceName(ClientDetailsPageState pageState) {
    return (pageState.client.customLeadSourceName != null && pageState.client.customLeadSourceName.isNotEmpty ? pageState.client.customLeadSourceName : ImageUtil.getLeadSourceText(pageState.client.leadSource));

  }

  void onAction(){
    _customLeadFocusNode.unfocus();
  }

  int getIconPosition(ClientDetailsPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource);
  }

}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, ClientDetailsPageState>(
    converter: (store) => ClientDetailsPageState.fromStore(store),
    builder: (BuildContext context, ClientDetailsPageState pageState) =>
        ClientJobItem(
            job: pageState.clientJobs.elementAt(index),
            pageState: pageState,
        ),
  );
}

void onCallPressed(String phoneNum){
  if(phoneNum.isNotEmpty) IntentLauncherUtil.makePhoneCall(phoneNum);
}

void onEmailPressed(String email){
  if(email.isNotEmpty) IntentLauncherUtil.sendEmail(email, "", "");
}

void onSMSPressed(String sms){
  if(sms.isNotEmpty) IntentLauncherUtil.sendSMS(sms);
}
