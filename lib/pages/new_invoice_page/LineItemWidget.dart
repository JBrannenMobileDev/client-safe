import 'package:client_safe/models/LineItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineItemWidget extends StatelessWidget {
  final LineItem lineItem;
  final int index;
  final int length;
  final Function onDelete;

  LineItemWidget(this.lineItem, this.index, this.length, this.onDelete);

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
              index > 0 ? GestureDetector(
                onTap: () {
                  onDelete(index);
                },
                child: Text(
                  'X  ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    color: Color(ColorConstants.getPeachDark()),
                  ),
                ),
              ) : SizedBox(),
              Text(
                lineItem.itemName,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Raleway',
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
                  fontSize: 20.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Text(
                '\$' + (lineItem.itemPrice.toInt() * lineItem.itemQuantity).toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Raleway',
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