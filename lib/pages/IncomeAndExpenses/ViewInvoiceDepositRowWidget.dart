import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewInvoiceDepositRowWidget extends StatelessWidget{
  final Invoice invoice;
  final Job job;

  ViewInvoiceDepositRowWidget(this.invoice, this.job);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, top: 4.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 96.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Deposit  ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w400,
                    color: Color(
                        ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
          Text(
            (invoice.depositPaid
                ? '-'
                : '') + '\$' +
                job.depositAmount.toInt().toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w600,
              color: Color(
                  invoice.depositPaid
                      ? ColorConstants.getPrimaryBlack()
                      : ColorConstants
                      .getPrimaryBackgroundGrey()),
            ),
          ),
        ],
      ),
    );
  }

}