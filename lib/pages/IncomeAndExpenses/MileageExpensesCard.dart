
import 'package:dandylight/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/MileageExpenseItem.dart';
import 'package:dandylight/pages/common_widgets/dandylightTextWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/styles/Styles.dart';

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
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Mileage Expenses (' + pageState.selectedYear.toString() + ')',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      pageState.mileageExpensesForSelectedYear != null && pageState.mileageExpensesForSelectedYear.length > 3 ? TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          pageState.onViewAllExpensesSelected(0);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllExpensesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View all(' + pageState.mileageExpensesForSelectedYear.length.toString() + ')',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.primary_black),
                            ),
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
                      child: DandyLightTextWidget(
                        amount: pageState.mileageExpensesForSelectedYearTotal,
                        textSize: 48.0,
                        textColor: Color(ColorConstants.getPeachDark()),
                        fontWeight: FontWeight.w600,
                        isCurrency: true,
                        decimalPlaces: 2,
                      ),
                    ),
                    Container(
                      width: 264.0,
                      margin: EdgeInsets.only(top: 8.0),
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Color(ColorConstants.getPeachDark()),
                          width: 1.0,
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    DandyLightTextWidget(
                                      amount: pageState.totalMilesDriven,
                                      textSize: 26.0,
                                      textColor: Color(ColorConstants.getPrimaryBlack()),
                                      fontWeight: FontWeight.w600,
                                      isCurrency: false,
                                      decimalPlaces: 1,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        'mi',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants.primary_black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                                child: Text(
                                  'miles driven',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.primary_black),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(

                                children: [
                                  DandyLightTextWidget(
                                    amount: 0.575,
                                    textSize: 26.0,
                                    textColor: Color(ColorConstants.getPrimaryBlack()),
                                    fontWeight: FontWeight.w600,
                                    isCurrency: true,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3.0),
                                    child: Text(
                                      '/mi',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w600,
                                        color: Color(ColorConstants.primary_black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                                child: Text(
                                  'deduction rate',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.primary_black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : SizedBox(),
                pageState.mileageExpensesForSelectedYear.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:16.0, bottom: 16.0),
                  reverse: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: _listKey,
                  itemCount: _getItemCount(pageState),
                  itemBuilder: _buildItem,
                ) : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 16.0, right: 16.0),
                  height: 64.0,
                  child: Text(
                    'You have zero mileage expenses.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConstants.primary_black),
                    ),
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
      return 178.0;
    }else if(length == 1) {
      return 326.0;
    }else if(length == 2) {
      return 400.0;
    }else if(length == 3) {
      return 474.0;
    }else {
      return 494.0;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return MileageExpenseItem(mileageExpense: pageState.mileageExpensesForSelectedYear.elementAt(index), pageState: pageState);
  }
}
