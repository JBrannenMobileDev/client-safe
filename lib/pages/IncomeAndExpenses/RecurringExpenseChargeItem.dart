
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Charge.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/common_widgets/DandyLightTextWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class RecurringExpenseChargeItem extends StatelessWidget{
  final Charge charge;
  final RecurringExpense selectedExpense;
  final IncomeAndExpensesPageState pageState;
  RecurringExpenseChargeItem({this.charge, this.pageState, this.selectedExpense});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.0,
      child: FlatButton(
        onPressed: () {

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
                        image: AssetImage(charge.isPaid ?? true ? 'assets/images/icons/charge_paid_icon_blue.png' : 'assets/images/icons/charge_not_paid_icon_peach.png'),
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
                              TextFormatterUtil.formatDateStandard(charge.chargeDate),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w800,
                                color: Color(charge.isPaid ? ColorConstants.primary_black : ColorConstants.getPeachDark()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DandyLightTextWidget(
                          amount: charge.chargeAmount,
                          textSize: 20.0,
                          textColor: Color(charge.isPaid ? ColorConstants.primary_black : ColorConstants.getPeachDark()),
                          fontWeight: FontWeight.w600,
                          isCurrency: true,
                          decimalPlaces: 2,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16.0,
                    margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                    child: Checkbox(
                      value: charge.isPaid,
                      activeColor: Color(ColorConstants.getPrimaryColor()),
                      onChanged: (isChecked) {
                        pageState.onRecurringExpenseChargeChecked(charge, selectedExpense, isChecked);
                      },
                    ),
                  ),
                  Text(
                    charge.isPaid ? 'Paid' : 'Unpaid',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(charge.isPaid ? ColorConstants.primary_black : ColorConstants.getPeachDark()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}