

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ResponsesListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../utils/ColorConstants.dart';
import '../ResponsesPageState.dart';
import 'EditResponseBottomSheet.dart';
import 'NewResponseBottomSheet.dart';

class ResponsesGroupListWidget extends StatelessWidget {
  final int index;

  ResponsesGroupListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResponsesPageState>(
      converter: (store) => ResponsesPageState.fromStore(store),
      builder: (BuildContext context, ResponsesPageState pageState) =>
      Stack(
            children: [
              _buildItemDetailsWidget(pageState, index, context),
              pageState.items.elementAt(index).itemType == ResponsesListItem.RESPONSE && pageState.items.elementAt(index).response.message.isEmpty ? Container(
                margin: EdgeInsets.only(left: 32, top: 34),
                child: Text(
                  'message not set',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.error_red),
                  ),
                ),
              ) : SizedBox(),
              pageState.items.elementAt(index).itemType == ResponsesListItem.RESPONSE && !pageState.isEditEnabled ? Container(
                margin: EdgeInsets.only(right: 16, bottom: 8),
                padding: EdgeInsets.only(right: 8),
                height: 54,
                alignment: Alignment.centerRight,
                width: double.infinity,
                child: Icon(
                  Icons.chevron_right,
                  color: Color(ColorConstants.getPrimaryGreyMedium()),
                ),
              ) : SizedBox(),
            ],
        ),
    );
  }

  _buildItemDetailsWidget(ResponsesPageState pageState, int index, BuildContext context) {
    Widget result = SizedBox();

    switch(pageState.items.elementAt(index).itemType) {
      case ResponsesListItem.GROUP_TITLE:
        result = GestureDetector(
          onTap: () {

          },
          child: Container(
            alignment: Alignment.center,
            height: 54,
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
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
                color: Color(ColorConstants.getBlueDark()),
              ),
            ),
          ),
        );
        break;
      case ResponsesListItem.RESPONSE:
        result = GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
              builder: (context) {
                return EditResponseBottomSheet(pageState.items.elementAt(index));
              },
            );
          },
          child: Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 56,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(ColorConstants.getBlueLight()).withOpacity(0.5),
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
              pageState.isEditEnabled ? GestureDetector(
                onTap: () {
                  pageState.onDeleteSelected(pageState.items.elementAt(index));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(16),
                  height: 56,
                  alignment: Alignment.centerRight,
                  child: Image.asset('assets/images/icons/trash_icon_white.png', color: Color(ColorConstants.getBlueDark()),),
                ),
              ) : SizedBox(),
            ],
          ),
        );
        break;
      case ResponsesListItem.ADD_ANOTHER_BUTTON:
        result = GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
                builder: (context) {
                  return NewResponseBottomSheet(pageState.items.elementAt(index).groupName);
                },
              );
        },
        child: Container(
              alignment: Alignment.centerLeft,
              height: 54,
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32),
              padding: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(ColorConstants.getPrimaryWhite())
              ),
              child: Text(
                '+ ' + pageState.items.elementAt(index).title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getBlueDark()),
                ),
              ),
          ),
        );
        break;
    }
    return result;
  }
}
