import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';


class UnpaidInvoicesCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  UnpaidInvoicesCard({
    this.pageState});

  final IncomeAndExpensesPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: getContainerHeight(pageState.unpaidInvoices.length, pageState),
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
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Unpaid Invoices',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
                      ),
                      pageState.unpaidInvoices != null && pageState.unpaidInvoices.length > 3 ? TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          pageState.onViewAllSelected(true);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllInvoicesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'View all (' + pageState.unpaidInvoices.length.toString() + ')',
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),
                pageState.unpaidInvoices.length > 0 ? ListView.builder(
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
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'You have zero unpaid invoices.',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
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
      return 165.0;
    }else if(length == 1) {
      return 132.0;
    }else if(length == 2) {
      return 200.0;
    }else {
      return 288.0;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    List<Invoice> invoices = pageState.unpaidInvoices;
    return InvoiceItem(invoice: invoices.elementAt(index), pageState: pageState);
  }

  int _getItemCount(IncomeAndExpensesPageState pageState) {
    if(pageState.unpaidInvoices.length > 3) {
      return 3;
    } else {
      return pageState.unpaidInvoices.length;
    }
  }
}