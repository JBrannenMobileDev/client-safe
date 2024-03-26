import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/BalanceDueWidget.dart';
import 'package:dandylight/pages/new_invoice_page/DepositRowWidget.dart';
import 'package:dandylight/pages/new_invoice_page/DiscountRowWidget.dart';
import 'package:dandylight/pages/new_invoice_page/GrayDividerWidget.dart';
import 'package:dandylight/pages/new_invoice_page/LineItemListWidget.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_invoice_page/SalesTaxRowWidget.dart';
import 'package:dandylight/pages/new_invoice_page/SubtotalRowWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/PdfUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../widgets/TextDandyLight.dart';

class InvoiceReviewPage extends StatefulWidget {

  @override
  _InvoiceReviewPageState createState() {
    return _InvoiceReviewPageState();
  }
}

class _InvoiceReviewPageState extends State<InvoiceReviewPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
      Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 26.0),
                alignment: Alignment.center,
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Invoice review',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, bottom: 0.0),
                alignment: Alignment.centerLeft,
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Line items',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              LineItemListWidget(pageState, true),
              GrayDividerWidget(),
              SubtotalRowWidget(pageState),
              pageState.selectedJob != null ? (pageState.selectedJob!.isDepositPaid() ? DepositRowWidget() : SizedBox()) : SizedBox(),
              pageState.discountValue! > 0 ? DiscountRowWidget(pageState) : SizedBox(),
              pageState.isSalesTaxChecked! ? SalesTaxRowWidget() : SizedBox(height: 16.0,),
              SizedBox(height: 16.0,),
              GrayDividerWidget(),
              BalanceDueWidget(pageState),
              pageState.dueDate != null ? Container(
                margin: EdgeInsets.only(left: 16.0, bottom: 0.0),
                alignment: Alignment.centerLeft,
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Due date:   ' + DateFormat('MMM dd, yyyy').format(pageState.dueDate!),
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ) : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}