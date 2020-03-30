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
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
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
  int selectedIndex = 0;
  Map<int, Widget> tabs;

  @override
  Widget build(BuildContext context) {
    tabs = <int, Widget>{
      0: Text(IncomeAndExpensesPage.FILTER_TYPE_INCOME, style: TextStyle(
        fontFamily: 'Raleway',
        color: Color(selectedIndex == 0
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),),
      1: Text(IncomeAndExpensesPage.FILTER_TYPE_EXPENSES, style: TextStyle(
        fontFamily: 'Raleway',
        color: Color(selectedIndex == 1
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),),
    };
    return StoreConnector<AppState, JobsPageState>(
        converter: (store) => JobsPageState.fromStore(store),
        builder: (BuildContext context, JobsPageState pageState) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
//                color: Color(ColorConstants.getPrimaryColor()),
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
                            'Income & Expenses',
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
                              UserOptionsUtil.showNewInvoiceDialog(context);
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
                                    child: CupertinoSlidingSegmentedControl<int>(
                                      thumbColor: Color(ColorConstants.getPrimaryColor()),
                                      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                                      children: tabs,
                                      onValueChanged: (int filterTypeIndex) {
                                        setState(() {
                                          selectedIndex = filterTypeIndex;
                                        });
                                        pageState.onFilterChanged(filterTypeIndex == 0 ? IncomeAndExpensesPage.FILTER_TYPE_INCOME : IncomeAndExpensesPage.FILTER_TYPE_EXPENSES);
                                      },
                                      groupValue: selectedIndex,
                                    ),
                                  ),
                                  preferredSize: Size.fromHeight(44.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 48.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 96.0,
                                      height: 96.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(48.0),
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                      child: Image(
                                        height: 64.0,
                                        width: 64.0,
                                        image: AssetImage("assets/images/income_and_expenses/piggybank.png"),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(

                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Income',
                                                style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 8.0, top: 2.0),
                                              padding: EdgeInsets.only(bottom: 2.0),
                                              alignment: Alignment.center,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16.0),
                                                border: Border.all(
                                                    width: 1,
                                                  color: Color(ColorConstants.getPrimaryWhite())
                                                ),
                                              ),
                                              child: FlatButton(
                                                onPressed: () {
                                                  DatePicker.showDatePicker(
                                                    context,
                                                    dateFormat:'yyyy',
                                                    onConfirm: (dateTime, intList) {

                                                    }
                                                  );
                                                },
                                                child: Text(
                                                  '2020',
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway',
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(ColorConstants.getPrimaryWhite()),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            '\$5,250',
                                            style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 48.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getPrimaryWhite()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
}
