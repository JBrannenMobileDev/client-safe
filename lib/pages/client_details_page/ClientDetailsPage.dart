import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:client_safe/pages/new_job_page/NewJobPage.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                        fontFamily: 'Raleway',
                        color: const Color(ColorConstants.primary_black),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Color(ColorConstants.getPrimaryColor()),
                        tooltip: 'Delete',
                        onPressed: () {
                          _ackAlert(context, pageState);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Color(ColorConstants.getPrimaryColor()),
                        tooltip: 'Edit',
                        onPressed: () {
                          pageState.onEditClientClicked(pageState.client);
                          UserOptionsUtil.showNewContactDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.info),
                        color: Color(ColorConstants.getPrimaryColor()),
                        tooltip: 'Info',
                        onPressed: () {
                        },
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClientSafeButton(
                                  height: 48.0,
                                  width: 65.0,
                                  text: "",
                                  marginLeft: 32.0,
                                  marginTop: 0.0,
                                  marginRight: 4.0,
                                  marginBottom: 0.0,
                                  onPressed: onCallPressed,
                                  icon: Icon(Icons.phone, color: Colors.white),
                                  urlText: pageState.client?.phone,
                              ),
                              ClientSafeButton(
                                height: 48.0,
                                width: 65.0,
                                text: "",
                                marginLeft: 4.0,
                                marginTop: 0.0,
                                marginRight: 4.0,
                                marginBottom: 0.0,
                                onPressed: onSMSPressed,
                                icon: Icon(Icons.message, color: Colors.white),
                                urlText: pageState.client?.phone,
                              ),
                              ClientSafeButton(
                                height: 48.0,
                                width: 65.0,
                                text: "",
                                marginLeft: 4.0,
                                marginTop: 0.0,
                                marginRight: 4.0,
                                marginBottom: 0.0,
                                onPressed: onEmailPressed,
                                icon: Icon(Icons.email, color: Colors.white),
                                urlText: pageState.client?.email,
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(left: 4.0, right: 32.0),
                                child: SizedBox(
                                  width: 65.0,
                                  height: 48.0,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0.0),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(8.0),
                                        side: BorderSide(color: Color(ColorConstants.getPrimaryColor()))),
                                    onPressed: () {
                                      pageState.onInstagramSelected();
                                    },
                                    color: Color(ColorConstants.getPrimaryColor()),
                                    child: Container(
                                      height: 32.0,
                                      width: 65.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/instagram_logo_icon.png"),
                                          fit: BoxFit.contain,
                                        ),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                      ),
                                    ),
                                  ),
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
                              fontSize: 22.0,
                              fontFamily: 'Raleway',
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
                            pageState.client != null? "You have not started any jobs with " + pageState.client?.getClientFullName() ?? "" + " yet. All jobs started for " + pageState.client?.getClientFullName() ?? "" + " will show up here." : '',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Raleway',
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
                width: double.infinity,
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
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
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
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
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
        JobInProgressItem(job: pageState.clientJobs.elementAt(index)),
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