
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class RecurringExpenseItem extends StatelessWidget{
  final RecurringExpense recurringExpense;
  final IncomeAndExpensesPageState pageState;
  RecurringExpenseItem({this.recurringExpense, this.pageState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.0,
      child: FlatButton(
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
                        child: Text(
                          TextFormatterUtil.formatSimpleCurrency(recurringExpense.cost.round()) + ' x ' + recurringExpense.getCountOfChargesForYear(pageState.selectedYear).toString() + '  =  ' + TextFormatterUtil.formatSimpleCurrency(recurringExpense.getTotalOfChargesForYear(pageState.selectedYear).round()),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(recurringExpense.cancelDate == null ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
                          ),
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