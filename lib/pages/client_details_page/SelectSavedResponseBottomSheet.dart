import 'package:dandylight/pages/client_details_page/ResponsesListItemWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../responses_page/ResponsesPage.dart';
import 'ClientDetailsPageActions.dart';
import 'ClientDetailsPageState.dart';


class SelectSavedResponseBottomSheet extends StatefulWidget {
  static const String TYPE_SMS = "Text";
  static const String TYPE_EMAIL = "Email";

  final String type;
  final String phoneOrEmail;

  SelectSavedResponseBottomSheet(this.type, this.phoneOrEmail);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState(type, phoneOrEmail);
  }
}

class _BottomSheetPageState extends State<SelectSavedResponseBottomSheet> with TickerProviderStateMixin {
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
           height: pageState.showNoSavedResponsesError ? 384 : getHeight(pageState.items.length),
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
              pageState.showNoSavedResponsesError ? Container(
                margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 16, bottom: 16),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Color(ColorConstants.getPrimaryBackgroundGrey())),
                    color: Color(ColorConstants.getPrimaryWhite())
                ),
                child: Column(
                  children: [
                    Text(
                      'You have not saved any responses yet. Go to your (Response Collection) page to save some response templates.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w400,
                        color: Color(ColorConstants.getPrimaryGreyMedium()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => ResponsesPage()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: 200,
                        margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.0),
                            color: Color(ColorConstants.getBlueLight())
                        ),
                        child:Text(
                          'Response Collection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Container(
                child: ListView.builder(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 64.0),
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

  getHeight(int length) {
    double result = 850;

    switch(length) {
      case 1:
        result = 300;
        break;
      case 2:
        result = 356;
        break;
      case 3:
        result = 412;
        break;
      case 4:
        result = 468;
        break;
      case 5:
        result = 524;
        break;
      case 6:
        result = 580;
        break;
      case 7:
        result = 636;
        break;
      case 8:
        result = 792;
        break;
    }
    return result;
  }
}