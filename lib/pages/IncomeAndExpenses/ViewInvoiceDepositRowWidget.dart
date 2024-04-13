import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/TextDandyLight.dart';

class ViewInvoiceDepositRowWidget extends StatelessWidget{
  final Invoice invoice;
  final Job job;

  ViewInvoiceDepositRowWidget(this.invoice, this.job);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 96.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Deposit  ',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ],
            ),
          ),
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: (invoice.depositPaid!
                ? '-'
                : '') + '\$' +
                (job.depositAmount != null ? job.depositAmount!.toInt().toString() : '0'),
            textAlign: TextAlign.start,
            color: Color(
                invoice.depositPaid!
                    ? ColorConstants.getPrimaryBlack()
                    : ColorConstants
                    .getPrimaryBackgroundGrey()),
          ),
        ],
      ),
    );
  }

}