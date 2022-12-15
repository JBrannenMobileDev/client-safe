

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ResponsesListItem.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../utils/ColorConstants.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'SendMessageBottomSheet.dart';

class ResponsesListItemWidget extends StatelessWidget {
  final int index;
  final String type;
  final String phoneOrEmail;

  ResponsesListItemWidget(this.index, this.type, this.phoneOrEmail);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          _buildItemDetailsWidget(pageState, index, context)
    );
  }

  _buildItemDetailsWidget(ClientDetailsPageState pageState, int index, BuildContext context) {
    Widget result = SizedBox();

    switch(pageState.items.elementAt(index).itemType) {
      case ResponsesListItem.NEW_RESPONSE:
        result = GestureDetector(
          onTap: () {
            switch(type) {
              case SendMessageBottomSheet.TYPE_SMS:
                IntentLauncherUtil.sendSMS(phoneOrEmail);
                EventSender().sendEvent(eventName: EventNames.BT_SEND_TEXT);
                break;
              case SendMessageBottomSheet.TYPE_EMAIL:
                IntentLauncherUtil.sendEmail(phoneOrEmail, '', '');
                EventSender().sendEvent(eventName: EventNames.BT_SEND_EMAIL);
                break;
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 56,
            margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 32),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(ColorConstants.getBlueDark())
            ),
            child: Text(
              pageState.items.elementAt(index).title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.getPrimaryWhite()),
              ),
            ),
          ),
        );
        break;
        break;
      case ResponsesListItem.GROUP_TITLE:
        result = GestureDetector(
          onTap: () {

          },
          child: Container(
            alignment: Alignment.center,
            height: 54,
            margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(ColorConstants.getPrimaryWhite())
            ),
            child:Text(
              pageState.items.elementAt(index).title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w400,
                color: Color(ColorConstants.getPrimaryGreyMedium()),
              ),
            ),
          ),
        );
        break;
      case ResponsesListItem.RESPONSE:
        result = GestureDetector(
          onTap: () {
            switch(type) {
              case SendMessageBottomSheet.TYPE_SMS:
                IntentLauncherUtil.sendSMSWithBody(phoneOrEmail, pageState.items.elementAt(index).response.message);
                EventSender().sendEvent(eventName: EventNames.BT_SEND_SAVED_TEXT);
                break;
              case SendMessageBottomSheet.TYPE_EMAIL:
                IntentLauncherUtil.sendEmail(phoneOrEmail, '', pageState.items.elementAt(index).response.message);
                EventSender().sendEvent(eventName: EventNames.BT_SEND_SAVED_EMAIL);
                break;
            }
          },
          child: Container(
            alignment: Alignment.centerLeft,
            height: 56,
            margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 8),
            padding: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(ColorConstants.getBlueLight()).withOpacity(0.5)
            ),
            child: Text(
              pageState.items.elementAt(index).title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w400,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
          ),
        );
        break;
      case ResponsesListItem.ADD_ANOTHER_BUTTON:
        result = SizedBox();
        break;
    }
    return result;
  }
}
