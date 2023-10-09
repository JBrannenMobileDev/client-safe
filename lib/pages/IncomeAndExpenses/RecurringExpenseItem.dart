
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class RecurringExpenseItem extends StatelessWidget{
  final RecurringExpense recurringExpense;
  final IncomeAndExpensesPageState pageState;
  RecurringExpenseItem({this.recurringExpense, this.pageState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.0,
      child: TextButton(
        style: Styles.getButtonStyle(),
        onPressed: () async {
          NavigationUtil.onRecurringChargeSelected(context, recurringExpense);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 12.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 18.0, top: 0.0),
                    height: 42.0,
                    width: 42.0,
                    child: Image.asset(recurringExpense.cancelDate == null ? 'assets/images/icons/income_received.png' : 'assets/images/icons/cancel.png', color: Color(ColorConstants.getPeachDark()),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: (recurringExpense.expenseName != null ? recurringExpense.expenseName : 'Item name') + (recurringExpense.cancelDate != null ? ' • Canceled' : ''),
                              textAlign: TextAlign.start,
                              color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Row(

                          children: [
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              amount: recurringExpense.cost,
                              color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                              isCurrency: true
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: ' x ' + recurringExpense.getCountOfChargesForYear(pageState.selectedYear).toString() + '  =  ',
                              textAlign: TextAlign.start,
                              color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              amount: recurringExpense.getTotalOfChargesForYear(pageState.selectedYear),
                              color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                              isCurrency: true
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: Icon(
                  Icons.chevron_right,
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}