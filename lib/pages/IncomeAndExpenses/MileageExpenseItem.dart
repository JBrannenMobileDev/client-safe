import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class MileageExpenseItem extends StatelessWidget{
  final MileageExpense? mileageExpense;
  final IncomeAndExpensesPageState? pageState;
  MileageExpenseItem({this.mileageExpense, this.pageState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.0,
      child: TextButton(
        style: Styles.getButtonStyle(),
        onPressed: () async {
          pageState!.onMileageExpenseItemSelected!(mileageExpense!);
          UserOptionsUtil.showNewMileageExpenseSelected(context, null);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 12.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 18.0, top: 0.0),
                    height: 42.0,
                    width: 42.0,
                    child: Image.asset('assets/images/icons/directions.png', color: Color(ColorConstants.getPeachDark()),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: DateFormat('MMM dd, yyyy').format(mileageExpense!.charge!.chargeDate!),
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              amount: mileageExpense!.totalMiles,
                              color: Color(ColorConstants.getPrimaryBlack()),
                              isNumber: true,
                              decimalPlaces: 1,
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'mi  •  ',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              amount: mileageExpense!.charge!.chargeAmount,
                              color: Color(ColorConstants.getPrimaryBlack()),
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