import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';
import 'package:dandylight/pages/responses_page/widgets/ResponsesGroupListWidget.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:redux/redux.dart';

import '../../utils/Shadows.dart';
import 'ResponsesActions.dart';

class ResponsesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResponsePageState();
  }

}


class _ResponsePageState extends State<ResponsesPage> with TickerProviderStateMixin {
  bool dialVisible = true;
  bool isFabExpanded = false;
  ScrollController _controller;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ResponsesPageState>(
        onInit: (store) {
          store.dispatch(FetchResponsesAction(store.state.responsesPageState));
        },
        converter: (Store<AppState> store) => ResponsesPageState.fromStore(store),
        builder: (BuildContext context, ResponsesPageState pageState) =>
            Scaffold(
              backgroundColor: Color(ColorConstants.getBlueLight()),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                    ),
                    brightness: Brightness.light,
                    backgroundColor: Color(ColorConstants.getBlueLight()),
                    pinned: true,
                    centerTitle: true,
                    title: Text(
                        "Responses",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'simple',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pageState.onEditSelected();
                        },
                        child: pageState.isEditEnabled ? Container(
                          margin: EdgeInsets.only(right: 24),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.close,
                            color: Color(ColorConstants.getPeachDark()),
                            size: 32,
                          ),
                        ) : Container(
                          margin: EdgeInsets.only(right: 26.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/trash_icon_white.png', color: Color(ColorConstants.getBlueDark()),),
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        Container(
                            height: (MediaQuery.of(context).size.height),
                            child: ListView.builder(
                              padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 250.0),
                              itemCount: pageState.items.length,
                              controller: _controller,
                              physics: AlwaysScrollableScrollPhysics(),
                              key: _listKey,
                              shrinkWrap: true,
                              reverse: false,
                              itemBuilder: _buildItem),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, ResponsesPageState>(
      converter: (store) => ResponsesPageState.fromStore(store),
      builder: (BuildContext context, ResponsesPageState pageState) =>
      ResponsesGroupListWidget(index),
    );
  }
}
