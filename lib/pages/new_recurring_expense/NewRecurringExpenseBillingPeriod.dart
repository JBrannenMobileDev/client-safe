import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';


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
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Select the billing period for this expense.',
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    pageState.onBillingPeriodSelected!(NewRecurringExpensePageState.BILLING_PERIOD_1MONTH);
                  },
                  child: Container(
                  alignment: Alignment.center,
                  height: 72.0,
                  width: 72.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_1MONTH ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: '1\nmonth',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.onBillingPeriodSelected!(NewRecurringExpensePageState.BILLING_PERIOD_3MONTHS);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_3MONTHS ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '3\nmonths',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
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
                    pageState.onBillingPeriodSelected!(NewRecurringExpensePageState.BILLING_PERIOD_6MONTHS);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_6MONTHS ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '6\nmonths',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.onBillingPeriodSelected!(NewRecurringExpensePageState.BILLING_PERIOD_1YEAR);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(pageState.billingPeriod == NewRecurringExpensePageState.BILLING_PERIOD_1YEAR ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryWhite())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '1\nyear',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
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
