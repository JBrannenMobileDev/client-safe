
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/MileageExpense.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/common_widgets/DandyLightTextWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MileageExpenseItem extends StatelessWidget{
  final MileageExpense mileageExpense;
  final IncomeAndExpensesPageState pageState;
  MileageExpenseItem({this.mileageExpense, this.pageState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.0,
      child: FlatButton(
        onPressed: () async {
          pageState.onMileageExpenseItemSelected(mileageExpense);
          UserOptionsUtil.showNewMileageExpenseSelected(context);
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
                        image: AssetImage('assets/images/icons/driving_directions_icon_peach.png'),
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
                              DateFormat('MMM dd, yyyy').format(mileageExpense.charge.chargeDate),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w800,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DandyLightTextWidget(
                              amount: mileageExpense.totalMiles,
                              textSize: 20.0,
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              fontWeight: FontWeight.w600,
                              isCurrency: false,
                              decimalPlaces: 1,
                            ),
                            Text(
                              'mi  •  ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                            DandyLightTextWidget(
                              amount: mileageExpense.charge.chargeAmount,
                              textSize: 20.0,
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              fontWeight: FontWeight.w600,
                              isCurrency: true,
                            )
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