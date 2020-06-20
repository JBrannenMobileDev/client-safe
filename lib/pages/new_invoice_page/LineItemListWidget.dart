import 'package:dandylight/pages/new_invoice_page/LineItemWidget.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineItemListWidget extends StatelessWidget{
  final NewInvoicePageState pageState;
  final bool shrinkWrap;

  LineItemListWidget(this.pageState, this.shrinkWrap);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          height: shrinkWrap ? _getHeight(pageState.lineItems.length) : 164.0,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: pageState.lineItems.length,
            itemBuilder: (context, index) {
              return LineItemWidget(
                  pageState.lineItems.elementAt(index), index, pageState.lineItems.length, pageState.onLineItemDeleted, pageState);
            },
          ),
        ),
        _getHeight(pageState.lineItems.length) == 164.0 ? Container(
          height: 64.0,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ) : SizedBox(),
        !shrinkWrap ? Container(
          margin: EdgeInsets.only(left: 8.0, bottom: 16.0),
          decoration: BoxDecoration(
              color: Color(
                  ColorConstants.getPrimaryColor()),
              borderRadius: BorderRadius.circular(24.0)
          ),
          width: 150.0,
          height: 28.0,
          child: FlatButton(
            onPressed: () {
              UserOptionsUtil.showNewLineItemDialog(context);
            },
            child: Text(
              'Add line item',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
                color: Color(
                    ColorConstants.getPrimaryWhite()),
              ),
            ),
          ),
        ) : SizedBox(),
      ],
    );
  }

  _getHeight(int length) {
    double height = length * 34.0;
    if(height <= 164.0) return height;
    return 164.0;
  }
}