import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_recurring_expense/NewRecurringExpenseCostTextField.dart';
import 'package:client_safe/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';


class NewRecurringExpenseBillingPeriod extends StatefulWidget {
  @override
  _NewRecurringExpenseBillingPeriod createState() {
    return _NewRecurringExpenseBillingPeriod();
  }
}

class _NewRecurringExpenseBillingPeriod extends State<NewRecurringExpenseBillingPeriod> with AutomaticKeepAliveClientMixin {

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
              padding: EdgeInsets.only(bottom: 32.0, top: 16.0),
              child: Text(
                'Select the billing period for this expense.',
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
                    pageState.onBillingPeriodSelected(NewRecurringExpensePageState.BILLING_PERIOD_1MONTH);
                  },
                  child: Container(
                  alignment: Alignment.center,
                  height: 72.0,
                  width: 72.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_1MONTH ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                  ),
                  child: Text(
                    '1\nmonth',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.onBillingPeriodSelected(NewRecurringExpensePageState.BILLING_PERIOD_3MONTHS);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_3MONTHS ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                    ),
                    child: Text(
                      '3\nmonths',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    pageState.onBillingPeriodSelected(NewRecurringExpensePageState.BILLING_PERIOD_6MONTHS);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_6MONTHS ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                    ),
                    child: Text(
                      '6\nmonths',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.onBillingPeriodSelected(NewRecurringExpensePageState.BILLING_PERIOD_1YEAR);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_1YEAR ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                    ),
                    child: Text(
                      '1\nyear',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
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