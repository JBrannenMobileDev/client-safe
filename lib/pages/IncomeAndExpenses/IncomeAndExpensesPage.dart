import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeGraphCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/MileageExpensesCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/RecurringExpensesCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/SingleExpenseCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/UnpaidInvoicesCard.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class IncomeAndExpensesPage extends StatefulWidget {
  static const String FILTER_TYPE_INCOME = "Income";
  static const String FILTER_TYPE_EXPENSES = "Expenses";

  @override
  State<StatefulWidget> createState() {
    return _IncomeAndExpensesPageState();
  }
}

class _IncomeAndExpensesPageState extends State<IncomeAndExpensesPage> {
  ScrollController _controller = ScrollController();

  final Map<int, Widget> tabs = const <int, Widget>{
    0: Text(IncomeAndExpensesPage.FILTER_TYPE_INCOME),
    1: Text(IncomeAndExpensesPage.FILTER_TYPE_EXPENSES),
  };

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, JobsPageState>(
        converter: (store) => JobsPageState.fromStore(store),
        builder: (BuildContext context, JobsPageState pageState) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                image: DecorationImage(
                  image: AssetImage(pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? ImageUtil.INCOME_BG : ImageUtil.EXPENSES_BG),
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.contain,
                ),
              ),
              height: 435.0,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        pinned: false,
                        floating: false,
                        forceElevated: false,
                        expandedHeight: 315.0,
                        centerTitle: true,
                        title: Center(
                          child: Text(
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? IncomeAndExpensesPage.FILTER_TYPE_INCOME : IncomeAndExpensesPage.FILTER_TYPE_EXPENSES,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Color(ColorConstants.getPrimaryWhite()),
                            tooltip: 'Add',
                            onPressed: () {
                              UserOptionsUtil.showNewJobDialog(context);
                            },
                          ),
                        ],
                        flexibleSpace: new FlexibleSpaceBar(
                          background: Column(

                            children: <Widget>[
                              SafeArea(
                                child: PreferredSize(
                                  child: Container(
                                    width: 300.0,
                                    margin: EdgeInsets.only(top: 56.0),
                                    child: CupertinoSegmentedControl<int>(
                                      borderColor: Color(ColorConstants.getPrimaryWhite()),
                                      selectedColor: Color(ColorConstants.getPrimaryWhite()),
                                      unselectedColor: Color(pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? ColorConstants.getBlueDark() : ColorConstants.getPeachDark()),
                                      children: tabs,
                                      onValueChanged: (int filterTypeIndex) {
                                        pageState.onFilterChanged(filterTypeIndex == 0 ? IncomeAndExpensesPage.FILTER_TYPE_INCOME : IncomeAndExpensesPage.FILTER_TYPE_EXPENSES);
                                      },
                                      groupValue: pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? 0 : 1,
                                    ),
                                  ),
                                  preferredSize: Size.fromHeight(44.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? IncomeGraphCard() : MileageExpensesCard(),
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? UnpaidInvoicesCard() : RecurringExpensesCard(),
                            pageState.filterType == IncomeAndExpensesPage.FILTER_TYPE_INCOME ? SizedBox() : SingleExpenseCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
