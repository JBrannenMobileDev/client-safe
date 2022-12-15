import 'package:dandylight/pages/client_details_page/ResponsesListItemWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../responses_page/widgets/ResponsesGroupListWidget.dart';
import 'ClientDetailsPageActions.dart';
import 'ClientDetailsPageState.dart';
import 'SelectSavedResponseBottomSheet.dart';


class SendMessageOptionsBottomSheet extends StatefulWidget {
  static const String TYPE_SMS = "Text";
  static const String TYPE_EMAIL = "Email";

  final String type;
  final String phoneOrEmail;

  SendMessageOptionsBottomSheet(this.type, this.phoneOrEmail);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState(type, phoneOrEmail);
  }
}

class _BottomSheetPageState extends State<SendMessageOptionsBottomSheet> with TickerProviderStateMixin {
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
           height: 300,
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
              GestureDetector(
                onTap: () {
                  switch(type) {
                    case SelectSavedResponseBottomSheet.TYPE_SMS:
                      IntentLauncherUtil.sendSMS(phoneOrEmail);
                      EventSender().sendEvent(eventName: EventNames.BT_SEND_TEXT);
                      break;
                    case SelectSavedResponseBottomSheet.TYPE_EMAIL:
                      IntentLauncherUtil.sendEmail(phoneOrEmail, '', '');
                      EventSender().sendEvent(eventName: EventNames.BT_SEND_EMAIL);
                      break;
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: Text(
                    'New Message',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
                    builder: (context) {
                      return SelectSavedResponseBottomSheet(type == SelectSavedResponseBottomSheet.TYPE_SMS ? SelectSavedResponseBottomSheet.TYPE_SMS : SelectSavedResponseBottomSheet.TYPE_EMAIL, phoneOrEmail);
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 32),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: Text(
                    'Select Saved Response',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
}