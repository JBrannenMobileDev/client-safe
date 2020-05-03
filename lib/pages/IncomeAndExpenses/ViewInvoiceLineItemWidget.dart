import 'package:client_safe/models/LineItem.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewInvoiceLineItemWidget extends StatelessWidget {
  final LineItem lineItem;
  final int index;
  final int length;

  ViewInvoiceLineItemWidget(this.lineItem, this.index, this.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: (index == length - 1) ? 112.0 : 32.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                lineItem.itemName,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                lineItem.itemQuantity > 1 ? ('(' + lineItem.itemQuantity.toString() + ' x \$' + lineItem.itemPrice.toInt().toString() + ')   ') : '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Text(
                '\$' + (lineItem.itemPrice.toInt() * lineItem.itemQuantity).toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}