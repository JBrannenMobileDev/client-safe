
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/TextFormatterUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class InvoiceItem extends StatelessWidget{
  final Invoice? invoice;
  final Function? onSendInvoiceSelected;
  final IncomeAndExpensesPageState? pageState;
  InvoiceItem({this.invoice, this.pageState, this.onSendInvoiceSelected});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () async {
        UserOptionsUtil.showViewInvoiceDialog(context, invoice, await JobDao.getJobById(invoice!.jobDocumentId!), onSendInvoiceSelected);
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
                  child: Image.asset('assets/images/icons/invoice.png', color: Color(ColorConstants.getPeachDark())),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: (invoice!.jobName != null ? invoice!.jobName : 'Job name'),
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: (invoice!.isOverdue() ? 'OVERDUE' :  (invoice!.dueDate != null ? ('Due: ' + DateFormat('MMM dd, yyyy').format(invoice!.dueDate!))
                                    : 'no due date')) + ' • ' + (invoice!.unpaidAmount != null ? TextFormatterUtil.formatDecimalDigitsCurrency(invoice!.unpaidAmount!, 2)
                                : '0'),
                        textAlign: TextAlign.start,
                        color: invoice!.isOverdue() ? Color(ColorConstants.getPeachDark()) : Color(ColorConstants.getPrimaryBlack()),
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