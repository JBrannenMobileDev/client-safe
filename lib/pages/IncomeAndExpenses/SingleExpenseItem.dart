import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class SingleExpenseItem extends StatelessWidget{
  final SingleExpense singleExpense;
  final IncomeAndExpensesPageState pageState;
  SingleExpenseItem({this.singleExpense, this.pageState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.0,
      child: TextButton(
        style: Styles.getButtonStyle(),
        onPressed: () async {
          pageState.onSingleExpenseItemSelected(singleExpense);
          UserOptionsUtil.showNewSingleExpenseDialog(context);
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
                        image: AssetImage('assets/images/icons/coin_icon_peach.png'),
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
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: (singleExpense.expenseName != null ? singleExpense.expenseName : 'Item name'),
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
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
                              text: DateFormat('MMM dd, yyyy').format(singleExpense.charge.chargeDate) + '  •  ',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.primary_black),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              amount: singleExpense.charge.chargeAmount,
                              color: Color(ColorConstants.getPrimaryBlack()),
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