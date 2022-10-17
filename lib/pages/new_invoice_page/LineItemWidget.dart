import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineItemWidget extends StatelessWidget {
  final LineItem lineItem;
  final int index;
  final int length;
  final Function onDelete;
  final NewInvoicePageState pageState;

  LineItemWidget(this.lineItem, this.index, this.length, this.onDelete, this.pageState);

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
              index > 0 && pageState.pageViewIndex != 3 ? GestureDetector(
                onTap: () {
                  onDelete(index);
                },
                child: Text(
                  'X  ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w800,
                    color: Color(ColorConstants.getPeachDark()),
                  ),
                ),
              ) : SizedBox(),
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
                lineItem.itemQuantity > 1 ? ('(' + lineItem.itemQuantity.toString() + ' x ' + TextFormatterUtil.formatSimpleCurrency(lineItem.itemPrice.toInt()) + ')   ') : '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Text(
                TextFormatterUtil.formatSimpleCurrency(lineItem.itemPrice.toInt() * lineItem.itemQuantity),
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