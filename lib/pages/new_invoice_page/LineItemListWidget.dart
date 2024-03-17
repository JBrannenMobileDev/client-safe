import 'package:dandylight/pages/new_invoice_page/LineItemWidget.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/TextDandyLight.dart';

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
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
          height: pageState.pageViewIndex == 3 ? 184 : 268,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: pageState.lineItems!.length,
            itemBuilder: (context, index) {
              return LineItemWidget(
                  pageState.lineItems!.elementAt(index), index, pageState.lineItems!.length, pageState.onLineItemDeleted!, pageState);
            },
          ),
        ),
        !shrinkWrap ? Container(
          margin: EdgeInsets.only(left: 8.0, bottom: 16.0),
          decoration: BoxDecoration(
              color: Color(
                  ColorConstants.getPrimaryColor()),
              borderRadius: BorderRadius.circular(24.0)
          ),
          width: 150.0,
          height: 28.0,
          child: TextButton(
            style: Styles.getButtonStyle(),
            onPressed: () {
              UserOptionsUtil.showNewLineItemDialog(context);
            },
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Add line item',
              textAlign: TextAlign.start,
              color: Color(
                  ColorConstants.getPrimaryWhite()),
            ),
          ),
        ) : SizedBox(),
      ],
    );
  }
}