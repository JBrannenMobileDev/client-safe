import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/PdfViewerPage.dart';
import 'package:client_safe/pages/new_invoice_page/BalanceDueWidget.dart';
import 'package:client_safe/pages/new_invoice_page/DepositRowWidget.dart';
import 'package:client_safe/pages/new_invoice_page/DiscountRowWidget.dart';
import 'package:client_safe/pages/new_invoice_page/GrayDividerWidget.dart';
import 'package:client_safe/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:client_safe/pages/new_invoice_page/LineItemListWidget.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceDialog.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:client_safe/pages/new_invoice_page/PriceBreakdownForm.dart';
import 'package:client_safe/pages/new_invoice_page/SubtotalRowWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/PdfUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

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
                child: Text(
                  'Invoice review',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, bottom: 0.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Line items',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w800,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              LineItemListWidget(pageState, true),
              GrayDividerWidget(),
              SubtotalRowWidget(pageState),
              pageState.selectedJob.isDepositPaid() ? DepositRowWidget(pageState) : SizedBox(),
              pageState.discountValue > 0 ? DiscountRowWidget(pageState) : SizedBox(height: 16.0,),
              GrayDividerWidget(),
              BalanceDueWidget(pageState),
              pageState.dueDate != null ? Container(
                margin: EdgeInsets.only(right: 16.0, bottom: 0.0),
                alignment: Alignment.centerRight,
                child: Text(
                  'Due date:   ' + DateFormat('MMM dd, yyyy').format(pageState.dueDate),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ) : SizedBox(),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      String path = await PdfUtil.getInvoiceFilePath(pageState.invoiceNumber);
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PdfViewerPage(path: path)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      height: 72.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueLight()),
                          borderRadius: BorderRadius.circular(36.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                              'assets/images/icons/pdf_icon_white.png'),
                          Text(
                            'View PDF',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}