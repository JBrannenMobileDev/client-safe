
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class PaidInvoiceItem extends StatelessWidget{
  final Invoice invoice;
  final Function onSendInvoiceSelected;
  final IncomeAndExpensesPageState pageState;
  PaidInvoiceItem({this.invoice, this.pageState, this.onSendInvoiceSelected});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        UserOptionsUtil.showViewInvoiceDialog(context, invoice, await JobDao.getJobById(invoice.jobId), onSendInvoiceSelected);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 12.0),
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
                        '\$' + (invoice.total - invoice.discount != null
                                ? (invoice.total - invoice.discount).truncate().toString()
                                : '0'),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
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