import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/VewInvoiceLineItemListWidget.dart';
import 'package:dandylight/pages/IncomeAndExpenses/ViewInvoiceBalanceDueWidget.dart';
import 'package:dandylight/pages/IncomeAndExpenses/ViewInvoiceDepositRowWidget.dart';
import 'package:dandylight/pages/IncomeAndExpenses/ViewInvoiceDiscountRowWidget.dart';
import 'package:dandylight/pages/IncomeAndExpenses/ViewInvoiceSubtotalRowWidget.dart';
import 'package:dandylight/pages/new_invoice_page/GrayDividerWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:dandylight/utils/PdfUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../navigation/routes/RouteNames.dart';
import '../../utils/UidUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'ViewSalesTaxRowWidget.dart';

class ViewInvoiceDialog extends StatefulWidget {
  final Invoice invoice;
  final Job job;
  final Function? onSendInvoiceSelected;

  ViewInvoiceDialog(this.invoice, this.job, this.onSendInvoiceSelected);

  @override
  _ViewInvoiceDialogState createState() {
    return _ViewInvoiceDialogState(invoice, job, onSendInvoiceSelected);
  }
}

class _ViewInvoiceDialogState extends State<ViewInvoiceDialog> with AutomaticKeepAliveClientMixin {
  final Invoice invoice;
  final Job job;
  final Function? onSendInvoiceSelected;

  _ViewInvoiceDialogState(this.invoice, this.job, this.onSendInvoiceSelected);

  Future<void> _ackAlert(BuildContext context, IncomeAndExpensesPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This invoice will be gone forever!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected!(invoice);
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This invoice will be gone forever!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected!(invoice);
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      converter: (store) => IncomeAndExpensesPageState.fromStore(store),
      builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
          Dialog(
            insetPadding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                        icon: Image.asset('assets/images/icons/trash_can.png', color: Color(ColorConstants.getPeachDark()), height: 26,),
                        tooltip: 'Delete Invoice',
                        onPressed: () {
                          _ackAlert(context, pageState);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Invoice " + invoice.invoiceId.toString(),
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
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
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Invoice review',
                                      textAlign: TextAlign.start,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0, bottom: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: TextDandyLight(
                                      type: TextDandyLight.LARGE_TEXT,
                                      text: 'Line items',
                                      textAlign: TextAlign.start,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  VewInvoiceLineItemListWidget(invoice, true),
                                  GrayDividerWidget(),
                                  ViewInvoiceSubtotalRowWidget(invoice),
                                  invoice.depositPaid! ? ViewInvoiceDepositRowWidget(invoice, job) : SizedBox(),
                                  invoice.discount! > 0 ? ViewInvoiceDiscountRowWidget(invoice) : SizedBox(),
                                  invoice.salesTaxRate! > 0 ? ViewSalesTaxRowWidget(invoice) : SizedBox(),
                                  GrayDividerWidget(),
                                  ViewInvoiceBalanceDueWidget(invoice),
                                  invoice.dueDate != null ? Container(
                                    margin: EdgeInsets.only(right: 16.0, bottom: 0.0, left: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: 'Due date:',
                                          textAlign: TextAlign.start,
                                          color: Color(ColorConstants.getPrimaryBlack()),
                                        ),
                                        TextDandyLight(
                                          type: TextDandyLight.MEDIUM_TEXT,
                                          text: DateFormat('MMM dd, yyyy').format(invoice.dueDate!),
                                          textAlign: TextAlign.start,
                                          color: Color(ColorConstants.getPrimaryBlack()),
                                        ),
                                      ],
                                    ),
                                  ) : SizedBox(),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              NavigationUtil.onShareWIthClientSelected(context, job);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                              padding: EdgeInsets.all(12.0),
                                              height: 54.0,
                                              width: 250.0,
                                              decoration: BoxDecoration(
                                                  color: Color(ColorConstants.getPeachDark()),
                                                  borderRadius: BorderRadius.circular(36.0)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  TextDandyLight(
                                                    type: TextDandyLight.MEDIUM_TEXT,
                                                    text: 'View in Client Portal',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryWhite()),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Cancel',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
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