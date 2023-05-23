import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/client_details_page/ImportantDatesWidget.dart';
import 'package:dandylight/pages/client_details_page/JobHistoryWidget.dart';
import 'package:dandylight/pages/client_details_page/LeadSourceWidget.dart';
import 'package:dandylight/pages/client_details_page/NotesWidget.dart';
import 'package:dandylight/pages/client_details_page/SelectSavedResponseBottomSheet.dart';
import 'package:dandylight/pages/client_details_page/SendMessageOptionsBottomSheet.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class ClientDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientDetailsPage();
  }
}

class _ClientDetailsPage extends State<ClientDetailsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
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
                  title: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: pageState.client?.getClientFullName() ?? "",
                    color: const Color(ColorConstants.primary_black),
                  ),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pageState.onEditClientClicked(pageState.client);
                        UserOptionsUtil.showNewContactDialog(context, false);
                        EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "Client Details Page - Edit"});
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
                                  if (pageState.client.phone != null && pageState.client.phone.length > 0) {
                                    onSMSPressed(pageState.client.phone, context);
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
                                    onEmailPressed(pageState.client.email, context);
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
                                  if (pageState.client.instagramProfileUrl != null && pageState.client.instagramProfileUrl.length > 0) {
                                    IntentLauncherUtil.launchURL(pageState.client.instagramProfileUrl);
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
                      JobHistoryWidget(),
                      NotesWidget(),
                      LeadSourceWidget(),
                      ImportantDatesWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
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
          content: new Text('This contact will be permanently deleted!'),
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
          content: new Text('This contact will be permanently deleted!'),
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

  int getIconPosition(ClientDetailsPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource);
  }

}

void onCallPressed(String phoneNum){
  if(phoneNum.isNotEmpty) IntentLauncherUtil.makePhoneCall(phoneNum);
}

void onEmailPressed(String email, BuildContext context){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
    builder: (context) {
      return SendMessageOptionsBottomSheet(SelectSavedResponseBottomSheet.TYPE_EMAIL, email);
    },
  );
}

void onSMSPressed(String phoneNum, BuildContext context){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
    builder: (context) {
      return SendMessageOptionsBottomSheet(SelectSavedResponseBottomSheet.TYPE_SMS, phoneNum);
    },
  );
}
