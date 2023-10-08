
import 'package:dandylight/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/MileageExpenseItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NumberConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class MileageExpensesCard extends StatelessWidget {
  MileageExpensesCard({this.pageState});
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final IncomeAndExpensesPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getContainerHeight(pageState.mileageExpensesForSelectedYear.length, pageState),
      child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, pageState.mileageExpensesForSelectedYear.length > 3 ? 4 : 16.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Mileage Deduction (' + pageState.selectedYear.toString() + ')',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      pageState.mileageExpensesForSelectedYear != null && pageState.mileageExpensesForSelectedYear.length > 3 ? TextButton(
                        style: Styles.getButtonStyle(top: 0),
                        onPressed: () {
                          pageState.onViewAllExpensesSelected(0);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllExpensesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'View all(' + pageState.mileageExpensesForSelectedYear.length.toString() + ')',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),
                pageState.mileageExpensesForSelectedYear.length > 0 ?
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                        amount: pageState.mileageExpensesForSelectedYearTotal,
                        color: Color(ColorConstants.getPeachDark()),
                        isCurrency: true,
                        decimalPlaces: 0,
                      ),
                    ),
                    Container(
                      width: 264.0,
                      margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.LARGE_TEXT,
                                      amount: pageState.totalMilesDriven,
                                      color: Color(ColorConstants.getPeachDark()),
                                      isNumber: true,
                                      decimalPlaces: 1,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 2.0),
                                      child: TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: ' miles driven',
                                        textAlign: TextAlign.start,
                                        color: Color(ColorConstants.getPeachDark()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(

                                children: [
                                  TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    amount: NumberConstants.TAX_MILEAGE_DEDUCTION_RATE,
                                    color: Color(ColorConstants.getPeachDark()),
                                    isCurrency: true,
                                    decimalPlaces: 3,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3.0),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: '/mi',
                                      textAlign: TextAlign.end,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : SizedBox(),
                pageState.mileageExpensesForSelectedYear.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:16.0, bottom: 0.0),
                  reverse: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: _listKey,
                  itemCount: _getItemCount(pageState),
                  itemBuilder: _buildItem,
                ) : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 26.0, right: 26.0),
                  height: 64.0,
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'You have not added any trips yet. Select the + button to add a trip. ',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getItemCount(IncomeAndExpensesPageState pageState) {
    if(pageState.mileageExpensesForSelectedYear.length > 3) {
      return 3;
    } else {
      return pageState.mileageExpensesForSelectedYear.length;
    }
  }

  double getContainerHeight(int length, IncomeAndExpensesPageState pageState) {
    if(length == 0) {
      return 186.0;
    }else if(length == 1) {
      return 261.0;
    }else if(length == 2) {
      return 336.0;
    }else if(length == 3) {
      return 412.0;
    }else {
      return 432.0;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return MileageExpenseItem(mileageExpense: pageState.mileageExpensesForSelectedYear.elementAt(index), pageState: pageState);
  }
}
