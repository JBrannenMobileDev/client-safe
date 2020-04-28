import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepositRowWidget extends StatelessWidget{
  final NewInvoicePageState pageState;

  DepositRowWidget(this.pageState);

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
                pageState.pageViewIndex != 3 ? Container(
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                      color: Color(pageState.selectedJob.isDepositPaid() ? ColorConstants.getPrimaryColor() : ColorConstants.getPeachDark()),
                      borderRadius: BorderRadius.circular(24.0)
                  ),
                  width: 100.0,
                  height: 28.0,
                  child: FlatButton(
                    onPressed: () {
                      pageState.onDepositActionPressed();
                    },
                    child: Text(
                      pageState.selectedJob.isDepositPaid()
                          ? 'paid'
                          : 'unpaid',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ) : SizedBox(),
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
            (pageState.selectedJob.isDepositPaid()
                ? '-'
                : '') + '\$' +
                pageState.depositValue.toInt().toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w600,
              color: Color(
                  pageState.selectedJob.isDepositPaid()
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