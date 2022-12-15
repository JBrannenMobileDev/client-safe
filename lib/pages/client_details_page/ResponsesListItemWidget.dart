

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ResponsesListItem.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../utils/ColorConstants.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../responses_page/ResponsesPage.dart';
import 'SelectSavedResponseBottomSheet.dart';

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
      case ResponsesListItem.NO_SAVED_RESPONSES:
        result = Container(
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
                'You have not saved any ' + pageState.items.elementAt(index).groupName + ' responses yet. Go to your (Response Collection) page to save some response templates.',
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
        );
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
              case SelectSavedResponseBottomSheet.TYPE_SMS:
                IntentLauncherUtil.sendSMSWithBody(phoneOrEmail, pageState.items.elementAt(index).response.message);
                EventSender().sendEvent(eventName: EventNames.BT_SEND_SAVED_TEXT);
                break;
              case SelectSavedResponseBottomSheet.TYPE_EMAIL:
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
