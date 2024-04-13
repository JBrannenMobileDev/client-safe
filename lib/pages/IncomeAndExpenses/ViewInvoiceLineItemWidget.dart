import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/TextDandyLight.dart';

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
              TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: lineItem.itemName,
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: lineItem.itemQuantity! > 1 ? ('(' + lineItem.itemQuantity.toString() + ' x \$' + lineItem.itemPrice!.toInt().toString() + ')   ') : '',
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: '\$' + (lineItem.itemPrice!.toInt() * lineItem.itemQuantity!).toString(),
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ],
          )
        ],
      ),
    );
  }
}