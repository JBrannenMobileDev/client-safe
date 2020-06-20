import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseCostTextField.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';


class NewRecurringExpenseAutoPaySelection extends StatefulWidget {
  @override
  _NewRecurringExpenseAutoPaySelection createState() {
    return _NewRecurringExpenseAutoPaySelection();
  }
}

class _NewRecurringExpenseAutoPaySelection extends State<NewRecurringExpenseAutoPaySelection> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewRecurringExpensePageState>(
      converter: (store) => NewRecurringExpensePageState.fromStore(store),
      builder: (BuildContext context, NewRecurringExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 56.0, top: 16.0),
              child: Text(
                'Do you have auto-pay setup for this recurring expense?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    pageState.onAutoPaySelected(true);
                  },
                  child: Container(
                  alignment: Alignment.center,
                  height: 96.0,
                  width: 96.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(pageState.isAutoPay ? ColorConstants.getBlueLight() : ColorConstants.getPrimaryWhite())
                  ),
                  child: Text(
                    'Yes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(pageState.isAutoPay ? ColorConstants.getPrimaryWhite() : ColorConstants.primary_black),
                    ),
                  ),
                ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.onAutoPaySelected(false);
                  },
                  child: Container(
                  alignment: Alignment.center,
                  height: 96.0,
                  width: 96.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(!pageState.isAutoPay ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryWhite())
                  ),
                  child: Text(
                    'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(!pageState.isAutoPay ? ColorConstants.getPrimaryWhite() : ColorConstants.primary_black),
                    ),
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
