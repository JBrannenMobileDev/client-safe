import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:client_safe/pages/IncomeAndExpenses/PaidInvoiceItem.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class AllInvoicesPage extends StatefulWidget {
  static const String FILTER_TYPE_UNPAID = "Unpaid";
  static const String FILTER_TYPE_PAID = "Paid";

  @override
  State<StatefulWidget> createState() {
    return _AllInvoicesPageState();
  }
}

class _AllInvoicesPageState extends State<AllInvoicesPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  Map<int, Widget> filterNames;
  int selectorIndex = 0;

  @override
  Widget build(BuildContext context) {
    filterNames = <int, Widget>{
      0: Text(
        AllInvoicesPage.FILTER_TYPE_UNPAID,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),
      ),
      1: Text(AllInvoicesPage.FILTER_TYPE_PAID,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
        onInit: (store) {
          selectorIndex = store.state.incomeAndExpensesPageState.allInvoicesFilterType == AllInvoicesPage.FILTER_TYPE_UNPAID ? 0 : 1;
          filterNames = <int, Widget>{
            0: Text(
              AllInvoicesPage.FILTER_TYPE_UNPAID,
              style: TextStyle(
                fontFamily: 'simple',
                fontSize: 20.0,
                fontWeight: selectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                color: Color(selectorIndex == 0
                    ? ColorConstants.getPrimaryWhite()
                    : ColorConstants.getPrimaryBlack()),
              ),
            ),
            1: Text(AllInvoicesPage.FILTER_TYPE_PAID,
              style: TextStyle(
                fontFamily: 'simple',
                fontSize: 20.0,
                fontWeight: selectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                color: Color(selectorIndex == 1
                    ? ColorConstants.getPrimaryWhite()
                    : ColorConstants.getPrimaryBlack()),
              ),),
          };
          store.dispatch(FetchClientData(store.state.clientsPageState));
        },
        converter: (store) => IncomeAndExpensesPageState.fromStore(store),
        builder: (BuildContext context, IncomeAndExpensesPageState pageState) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.white,
                        pinned: true,
                        centerTitle: true,
                        title: Center(
                          child: Text(
                            "All Invoices",
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              UserOptionsUtil.showNewInvoiceDialog(context, null);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12.0),
                              height: 24.0,
                              width: 24.0,
                              child: Image.asset('assets/images/icons/plus_icon_peach.png'),
                            ),
                          ),
                        ],
                        bottom: PreferredSize(
                          child: Container(
                            width: 300.0,
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getPrimaryColor()),
                              children: filterNames,
                              onValueChanged: (int filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex;
                                });
                                pageState.onAllInvoicesFilterChanged(filterTypeIndex == 0 ? AllInvoicesPage.FILTER_TYPE_UNPAID : AllInvoicesPage.FILTER_TYPE_PAID);
                              },
                              groupValue: selectorIndex,
                            ),
                          ),
                          preferredSize: Size.fromHeight(44.0),
                        ),
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
                              itemCount: selectorIndex == 0 ? pageState.unpaidInvoices.length : pageState.paidInvoices.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
          ),
        ),
      );
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, IncomeAndExpensesPageState>(
    converter: (store) => IncomeAndExpensesPageState.fromStore(store),
    builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
        pageState.allInvoicesFilterType == AllInvoicesPage.FILTER_TYPE_UNPAID ? InvoiceItem(invoice: pageState.unpaidInvoices.elementAt(index)) : PaidInvoiceItem(invoice: pageState.paidInvoices.elementAt(index)),
  );
}
