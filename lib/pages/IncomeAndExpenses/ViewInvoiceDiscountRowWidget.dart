import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewInvoiceDiscountRowWidget extends StatelessWidget{
  final Invoice invoice;
  ViewInvoiceDiscountRowWidget(this.invoice);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 112.0),
                child: Text(
                  'Discount',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
            ],
          ),
          invoice.discount > 0.0 ? Text(
            (invoice.discount.toInt() > 0 ? '-' : '') + '\$' +
                (invoice.discount.toInt().toString()),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w600,
              color: Color(invoice.discount.toInt() > 0 ? ColorConstants
                  .getPrimaryBlack() : ColorConstants
                  .getPrimaryBackgroundGrey()),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}