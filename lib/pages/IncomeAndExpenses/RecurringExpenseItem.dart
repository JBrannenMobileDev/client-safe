
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/common_widgets/dandylightTextWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/styles/Styles.dart';

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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(recurringExpense.cancelDate == null ? 'assets/images/icons/coins_icon_peach.png' : 'assets/images/icons/cancel_icon_peach.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
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
                            Text(
                              (recurringExpense.expenseName != null ? recurringExpense.expenseName : 'Item name') + (recurringExpense.cancelDate != null ? ' • Canceled' : ''),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w800,
                                color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Row(

                          children: [
                            DandyLightTextWidget(
                              amount: recurringExpense.cost,
                              textSize: 20.0,
                              textColor: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                              fontWeight: FontWeight.w600,
                              isCurrency: true,
                              decimalPlaces: 2,
                            ),
                            Text(
                              ' x ' + recurringExpense.getCountOfChargesForYear(pageState.selectedYear).toString() + '  =  ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                              ),
                            ),
                            DandyLightTextWidget(
                              amount: recurringExpense.getTotalOfChargesForYear(pageState.selectedYear),
                              textSize: 20.0,
                              textColor: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                              fontWeight: FontWeight.w600,
                              isCurrency: true,
                              decimalPlaces: 2,
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