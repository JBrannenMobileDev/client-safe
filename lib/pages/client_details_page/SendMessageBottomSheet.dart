import 'package:dandylight/pages/client_details_page/ResponsesListItemWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../responses_page/widgets/ResponsesGroupListWidget.dart';
import 'ClientDetailsPageActions.dart';
import 'ClientDetailsPageState.dart';


class SendMessageBottomSheet extends StatefulWidget {
  static const String TYPE_SMS = "Text";
  static const String TYPE_EMAIL = "Email";

  final String type;
  final String phoneOrEmail;

  SendMessageBottomSheet(this.type, this.phoneOrEmail);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState(type, phoneOrEmail);
  }
}

class _BottomSheetPageState extends State<SendMessageBottomSheet> with TickerProviderStateMixin {
  ScrollController _controller;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String type;
  final String phoneOrEmail;

  _BottomSheetPageState(this.type, this.phoneOrEmail);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientDetailsPageState>(
    onInit: (store) {
      store.dispatch(FetchClientDetailsResponsesAction(store.state.clientDetailsPageState));
    },
    converter: (Store<AppState> store) => ClientDetailsPageState.fromStore(store),
    builder: (BuildContext context, ClientDetailsPageState pageState) =>
         Container(
           height: 850,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              color: Color(ColorConstants.getPrimaryWhite())),
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24, bottom: 24.0),
                child: Text(
                  'Select a message to send',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              Container(
                height: 774,
                child: ListView.builder(
                    padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 64.0),
                    itemCount: pageState.items.length,
                    controller: _controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    key: _listKey,
                    shrinkWrap: true,
                    reverse: false,
                    itemBuilder: _buildItem),
              ),
            ],
          ),
        ),
    );

  Widget _buildItem(BuildContext context, int index) {
    return ResponsesListItemWidget(index, type, phoneOrEmail);
  }
}