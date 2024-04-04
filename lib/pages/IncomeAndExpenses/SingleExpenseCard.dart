import 'package:dandylight/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/SingleExpenseItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';


class SingleExpenseCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  SingleExpenseCard({
    this.pageState});

  final IncomeAndExpensesPageState? pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getContainerHeight(pageState!.singleExpensesForSelectedYear!.length, pageState!),
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, pageState!.singleExpensesForSelectedYear!.length > 3 ? 4 : 16.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Single Expenses (' + pageState!.selectedYear!.toString() + ')',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      pageState!.singleExpensesForSelectedYear != null && pageState!.singleExpensesForSelectedYear!.length > 3 ? TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          pageState!.onViewAllExpensesSelected!(1);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllExpensesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: pageState!.isSingleExpensesMinimized! ? 'View all(' + pageState!.singleExpensesForSelectedYear!.length.toString() + ')' : 'Hide',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),
                pageState!.singleExpensesForSelectedYear!.length > 0 ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                    amount: pageState!.singleExpensesForSelectedYearTotal,
                    color: Color(ColorConstants.getPeachDark()),
                    isCurrency: true,
                    decimalPlaces: 0,
                  ),
                ) : SizedBox(),
                pageState!.singleExpensesForSelectedYear!.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:16.0, bottom: 16.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: _listKey,
                    itemCount: _getItemCount(pageState!),
                    itemBuilder: _buildItem,
                  ) : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 16.0, right: 16.0),
                  height: 64.0,
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'You have zero single expenses.',
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
    if(pageState.isSingleExpensesMinimized! && pageState.singleExpensesForSelectedYear!.length > 3) {
      return 3;
    } else {
      return pageState.singleExpensesForSelectedYear!.length;
    }
  }

  double getContainerHeight(int length, IncomeAndExpensesPageState pageState) {
    if(length == 0) {
      return 169.0;
    }else if(length == 1) {
      return 254.0;
    }else if(length == 2) {
      return 328.0;
    }else if(length == 3) {
      return 402.0;
    }else {
      return 412;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return SingleExpenseItem(singleExpense: pageState!.singleExpensesForSelectedYear!.elementAt(index), pageState: pageState!);
  }
}