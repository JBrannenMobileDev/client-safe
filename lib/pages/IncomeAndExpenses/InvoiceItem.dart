
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class InvoiceItem extends StatelessWidget{
  final Invoice invoice;
  final IncomeAndExpensesPageState pageState;
  InvoiceItem({this.invoice, this.pageState});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
//        pageState.onLeadClicked(client);
//        NavigationUtil.onClientTapped(context);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 18.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 18.0, top: 0.0),
                  height: 42.0,
                  width: 42.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/icons/invoices_icon_peach.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        (invoice.jobName != null ? invoice.jobName : 'Job name'),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        ((invoice.sentDate != null ? 'Due date: ' + DateFormat('MMM dd, yyyy').format(invoice.dueDate) : 'Unsent') + ' • \$' + (invoice.unpaidAmount != null ? invoice.unpaidAmount.truncate().toString() : '0')),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(invoice.sentDate != null ? ColorConstants.primary_black : ColorConstants.getPeachDark()),
                        ),
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
    );
  }
}