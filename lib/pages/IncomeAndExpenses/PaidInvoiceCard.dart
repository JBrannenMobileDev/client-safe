import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:dandylight/pages/IncomeAndExpenses/PaidInvoiceItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class PaidInvoiceCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  PaidInvoiceCard({
    this.pageState});

  final IncomeAndExpensesPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 128.0),
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: getContainerHeight(pageState.paidInvoices.length, pageState),
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Paid Invoices',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      pageState.paidInvoices != null && pageState.paidInvoices.length > 3 ? FlatButton(
                        onPressed: () {
                          pageState.onViewAllSelected(false);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllInvoicesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View all (' + pageState.paidInvoices.length.toString() + ')',
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
                pageState.paidInvoices.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:0.0, bottom: 16.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: _listKey,
                    itemCount: _getItemCount(pageState),
                    itemBuilder: _buildItem,
                  ) : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 16.0, right: 16.0),
                  height: 64.0,
                  child: Text(
                    'You have zero paid invoices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
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

  double getContainerHeight(int length, IncomeAndExpensesPageState pageState) {
    if(length == 0) {
      return 162.0;
    }else if(length == 1) {
      return 142.0;
    }else if(length == 2) {
      return 216.0;
    }else {
      return 304.0;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    List<Invoice> invoices = pageState.paidInvoices;
    return PaidInvoiceItem(invoice: invoices.elementAt(index), pageState: pageState);
  }

  int _getItemCount(IncomeAndExpensesPageState pageState) {
    if(pageState.paidInvoices.length > 3) {
      return 3;
    } else {
      return pageState.unpaidInvoices.length;
    }
  }
}