import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpenseChargeItem.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class RecurringExpenseDetailsPage extends StatefulWidget {
  final RecurringExpense? selectedExpense;
  RecurringExpenseDetailsPage(this.selectedExpense);

  @override
  State<StatefulWidget> createState() {
    return _RecurringExpenseDetailsPageState(selectedExpense);
  }
}

class _RecurringExpenseDetailsPageState extends State<RecurringExpenseDetailsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  final RecurringExpense? selectedExpense;
  
  _RecurringExpenseDetailsPageState(this.selectedExpense);
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
        converter: (store) => IncomeAndExpensesPageState.fromStore(store),
        builder: (BuildContext context, IncomeAndExpensesPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                        pinned: true,
                        centerTitle: true,
                        title: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: selectedExpense!.expenseName! + ' Charges',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              pageState.onEditRecurringExpenseItemSelected!(selectedExpense!);
                              UserOptionsUtil.showNewRecurringExpenseDialog(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12.0),
                              height: 24.0,
                              width: 24.0,
                              child: Image.asset('assets/images/icons/edit_icon_peach.png'),
                            ),
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: selectedExpense!.charges!.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          selectedExpense!.cancelDate == null ? pageState.onCancelRecurringSubscriptionSelected!(selectedExpense!) : pageState.onResumeRecurringSubscriptionSelected!(selectedExpense!);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          height: 64.0,
                          width: 272.0,
                          decoration: BoxDecoration(
                              color: Color(selectedExpense!.cancelDate != null ? ColorConstants.getBlueDark() : ColorConstants.getPeachDark()),
                              borderRadius: BorderRadius.circular(36.0)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: selectedExpense!.cancelDate == null ? 'Stop Recurring Expense' : 'Resume Recurring Expense',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
          ),
        ),
      );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      converter: (store) => IncomeAndExpensesPageState.fromStore(store),
      builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
          RecurringExpenseChargeItem(pageState: pageState, charge: selectedExpense!.charges!.reversed.toList().elementAt(index), selectedExpense: selectedExpense),
    );
  }
}
