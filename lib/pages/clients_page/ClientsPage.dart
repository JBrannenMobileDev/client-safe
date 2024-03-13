import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:dandylight/pages/clients_page/ClientsPageState.dart';
import 'package:dandylight/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class ClientsPage extends StatefulWidget {
  static const String FILTER_TYPE_CLIENTS = "Clients";
  static const String FILTER_TYPE_LEADS = "Leads";
  static const String FILTER_TYPE_ALL = "All";
  final bool? comingFromUnconverted;

  ClientsPage({this.comingFromUnconverted});

  @override
  State<StatefulWidget> createState() {
    return _ClientsPageState(comingFromUnconverted);
  }
}

class _ClientsPageState extends State<ClientsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String alphabet = "ABCDEFGHIGKLMNOPQRSTUVWXYZ";
  int selectorIndex = 0;
  ScrollController _controller = ScrollController();
  Map<int, Widget>? genders;
  bool? comingFromUnconverted;

  _ClientsPageState(this.comingFromUnconverted);

  @override
  void initState() {
    super.initState();
    if(comingFromUnconverted != null && comingFromUnconverted!) {
      selectorIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    genders = <int, Widget>{
      0: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: ClientsPage.FILTER_TYPE_ALL,
        color: Color(selectorIndex == 0
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      1: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: ClientsPage.FILTER_TYPE_CLIENTS,
        color: Color(selectorIndex == 1
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      2: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: ClientsPage.FILTER_TYPE_LEADS,
        color: Color(selectorIndex == 2
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
    };
    return StoreConnector<AppState, ClientsPageState>(
        onInit: (store) => store.dispatch(FetchClientData(store.state.clientsPageState)),
        converter: (store) => ClientsPageState.fromStore(store),
        builder: (BuildContext context, ClientsPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        leading: comingFromUnconverted != null && comingFromUnconverted! ? GestureDetector(
                          onTap:(){
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                            color: Color(ColorConstants.getPrimaryBlack()),//add color of your choice
                          ),
                        ) : SizedBox(),
                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                        pinned: true,
                        centerTitle: true,
                        title: Container(
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: "Contacts",
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              UserOptionsUtil.showNewContactDialog(context, false);
                              EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "Contacts Page"});
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 26.0),
                              height: 24.0,
                              width: 24.0,
                              child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPrimaryBlack()),),
                            ),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(44.0),
                          child: Container(
                            width: 300.0,
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getBlueLight()),
                              children: genders!,
                              onValueChanged: (int? filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex!;
                                });
                                pageState.onFilterChanged!(
                                    filterTypeIndex == 0
                                        ? ClientsPage.FILTER_TYPE_ALL : filterTypeIndex == 1
                                        ? ClientsPage.FILTER_TYPE_CLIENTS : ClientsPage.FILTER_TYPE_LEADS);
                              },
                              groupValue: selectorIndex,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: pageState.filterType == ClientsPage.FILTER_TYPE_ALL
                                  ? pageState.all!.length : pageState.filterType == ClientsPage.FILTER_TYPE_CLIENTS
                                  ? pageState.clients!.length : pageState.leads!.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
          ),
        ),
      );
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, ClientsPageState>(
    converter: (store) => ClientsPageState.fromStore(store),
    builder: (BuildContext context, ClientsPageState pageState) =>
        ClientListWidget(index),
  );
}
