import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/PdfViewerPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/VewInvoiceLineItemListWidget.dart';
import 'package:client_safe/pages/IncomeAndExpenses/ViewInvoiceBalanceDueWidget.dart';
import 'package:client_safe/pages/IncomeAndExpenses/ViewInvoiceDepositRowWidget.dart';
import 'package:client_safe/pages/IncomeAndExpenses/ViewInvoiceDiscountRowWidget.dart';
import 'package:client_safe/pages/IncomeAndExpenses/ViewInvoiceSubtotalRowWidget.dart';
import 'package:client_safe/pages/new_invoice_page/BalanceDueWidget.dart';
import 'package:client_safe/pages/new_invoice_page/DepositRowWidget.dart';
import 'package:client_safe/pages/new_invoice_page/DiscountRowWidget.dart';
import 'package:client_safe/pages/new_invoice_page/DueDateSelectionPage.dart';
import 'package:client_safe/pages/new_invoice_page/GrayDividerWidget.dart';
import 'package:client_safe/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:client_safe/pages/new_invoice_page/InvoiceReviewPage.dart';
import 'package:client_safe/pages/new_invoice_page/JobSelectionForm.dart';
import 'package:client_safe/pages/new_invoice_page/LineItemListWidget.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/PriceBreakdownForm.dart';
import 'package:client_safe/pages/new_invoice_page/SubtotalRowWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/KeyboardUtil.dart';
import 'package:client_safe/utils/PdfUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class ViewInvoiceDialog extends StatefulWidget {
  final Invoice invoice;
  final Job job;

  ViewInvoiceDialog(this.invoice, this.job);

  @override
  _ViewInvoiceDialogState createState() {
    return _ViewInvoiceDialogState(invoice, job);
  }
}

class _ViewInvoiceDialogState extends State<ViewInvoiceDialog> with AutomaticKeepAliveClientMixin {
  final Invoice invoice;
  final Job job;

  _ViewInvoiceDialogState(this.invoice, this.job);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      converter: (store) => IncomeAndExpensesPageState.fromStore(store),
      builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 450.0,
              height: 665.0,
              margin: EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 16.0, bottom: 16.0),
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Stack(

                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Close',
                        color: Color(ColorConstants.getPeachDark()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Text(
                          "Invoice " + invoice.invoiceId.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 563.0,
                          ),
                          child: Stack(
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
                                  VewInvoiceLineItemListWidget(invoice, true),
                                  GrayDividerWidget(),
                                  ViewInvoiceSubtotalRowWidget(invoice),
                                  invoice.depositPaid ? ViewInvoiceDepositRowWidget(invoice, job) : SizedBox(),
                                  invoice.discount > 0 ? ViewInvoiceDiscountRowWidget(invoice) : SizedBox(height: 16.0,),
                                  GrayDividerWidget(),
                                  ViewInvoiceBalanceDueWidget(invoice),
                                  invoice.dueDate != null ? Container(
                                    margin: EdgeInsets.only(right: 16.0, bottom: 0.0),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Due date:   ' + DateFormat('MMM dd, yyyy').format(invoice.dueDate),
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
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              String path = await PdfUtil.getInvoiceFilePath(invoice.invoiceId);
                                              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PdfViewerPage(path: path)));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                              padding: EdgeInsets.all(12.0),
                                              height: 54.0,
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
                                          GestureDetector(
                                            onTap: () async {
                                              String path = await PdfUtil.getInvoiceFilePath(invoice.invoiceId);
                                              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PdfViewerPage(path: path)));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                              padding: EdgeInsets.all(12.0),
                                              height: 54.0,
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                  color: Color(ColorConstants.getPrimaryColor()),
                                                  borderRadius: BorderRadius.circular(36.0)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                      'assets/images/icons/edit_icon_white.png'),
                                                  Text(
                                                    'Edit invoice',
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
                                          GestureDetector(
                                            onTap: () async {
                                              String path = await PdfUtil.getInvoiceFilePath(invoice.invoiceId);
                                              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PdfViewerPage(path: path)));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                              padding: EdgeInsets.all(12.0),
                                              height: 54.0,
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                  color: Color(ColorConstants.getPeachDark()),
                                                  borderRadius: BorderRadius.circular(36.0)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                      'assets/images/icons/sms_icon_white.png'),
                                                  Text(
                                                    invoice.sentDate != null ? 'Resend' : 'Send'+ ' invoice',
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  @override
  bool get wantKeepAlive => true;
}