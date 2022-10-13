import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/client_details_page/ClientJobItem.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
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

import '../../utils/styles/Styles.dart';

class ClientDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientDetailsPage();
  }
}

class _ClientDetailsPage extends State<ClientDetailsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientDetailsPageState>(
        converter: (store) => ClientDetailsPageState.fromStore(store),
        builder: (BuildContext context, ClientDetailsPageState pageState) =>
            Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                    expandedHeight: Device.get().isIphoneX ? 298.0 : 276.0,
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
                          UserOptionsUtil.showNewContactDialog(context);
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
                      background: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: Device.get().isIphoneX ? 92.0 : 72.0),
                                height: 116.0,
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        pageState.client?.iconUrl ?? ""),
                                    fit: BoxFit.contain,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if(pageState.client.phone != null && pageState.client.phone.length > 0){
                                    onCallPressed(pageState.client.phone);
                                  }else{
                                    DandyToastUtil.showErrorToast('No phone number saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset('assets/images/icons/phonecall_icon_white.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(pageState.client.phone != null && pageState.client.phone.length > 0){
                                    onSMSPressed(pageState.client.phone);
                                  }else{
                                    DandyToastUtil.showErrorToast('No phone number saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset('assets/images/icons/sms_icon_white.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(pageState.client.email != null && pageState.client.email.length > 0){
                                    onEmailPressed(pageState.client.email);
                                  }else{
                                    DandyToastUtil.showErrorToast('No email saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset('assets/images/icons/email_icon_white.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(pageState.client.instagramProfileUrl != null && pageState.client.instagramProfileUrl.length > 0){
                                    pageState.onInstagramSelected();
                                  }else{
                                    DandyToastUtil.showErrorToast('No Instagram URL saved yet');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryColor()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  height: 64.0,
                                  width: 64.0,
                                  child: Image.asset('assets/images/icons/instagram_icon_white.png'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 32.0),
                          child: Text(
                            'Jobs',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 26.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        pageState.clientJobs.length > 0 ? ListView.builder(
                          reverse: false,
                          padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                          shrinkWrap: true,
                          controller: _controller,
                          physics: ClampingScrollPhysics(),
                          key: _listKey,
                          itemCount: pageState.clientJobs.length,
                          itemBuilder: _buildItem,
                        ) : Container(
                          margin: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                          child: Text(
                            'Start a job to turn this lead into a client.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ClientSafeButton(
                height: 48.0,
                width: 200.0,
                text: "Start New Job",
                marginLeft: 32.0,
                marginTop: 0.0,
                marginRight: 32.0,
                marginBottom: Device.get().isIphoneX ? 52.0 : 22,
                onPressed: () {
                  _showNewJobDialog(pageState);
                },
                icon: Icon(Icons.business_center, color: Colors.white),
                urlText: "",
              ),
            ],
          ),
        ),
      );

  void _showNewJobDialog(ClientDetailsPageState pageState){
    pageState.onStartNewJobClicked(pageState.client);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewJobPage();
      },
    );
  }
}

Future<void> _ackAlert(BuildContext context, ClientDetailsPageState pageState) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Device.get().isIos ?
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
