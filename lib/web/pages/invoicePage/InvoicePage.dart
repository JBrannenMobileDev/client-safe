import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/web/pages/invoicePage/PayNowPage.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/TextFormatterUtil.dart';
import '../ClientPortalPageState.dart';

class InvoicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InvoicePageState();
  }
}

class _InvoicePageState extends State<InvoicePage> {
  bool isHoveredDownloadPDF = false;
  bool isHoveredPayDeposit = false;
  bool isHoveredPayFull = false;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientPortalPageState>(
      converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
      builder: (BuildContext context, ClientPortalPageState pageState) => Container(
        alignment: Alignment.topCenter,
        width: 1080,
        color: Color(ColorConstants.getPrimaryWhite()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 32, bottom: 48),
                  child: TextDandyLight(
                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                    text: 'Invoice',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32, right: 16),
                  alignment: Alignment.centerRight,
                  width: 1080,
                  child: MouseRegion(
                    child: GestureDetector(
                      onTap: () {
                        pageState.onDownloadInvoiceSelected();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 116 : 48,
                        height: 48,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(ColorConstants.getPeachDark())),
                        child: Row(
                          mainAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              child: Image.asset(
                                "images/icons/download.png",
                                color:
                                Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                            DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'PDF',
                              color: Color(ColorConstants.getPrimaryWhite()),
                              isBold: isHoveredDownloadPDF,
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    cursor: SystemMouseCursors.click,
                    onHover: (event) {
                      setState(() {
                        isHoveredDownloadPDF = true;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        isHoveredDownloadPDF = false;
                      });
                    },
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              width: 1080,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Retainer',
                          isBold: true,
                        ),
                      ),
                      pageState.invoice.depositPaid ? Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          text: 'PAID',
                        ),
                      ) : Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Due:  ' + (pageState.invoice.depositDueDate != null
                              ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.invoice.depositDueDate)
                              : 'TBD'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.depositAmount),
                        ),
                      ),
                      MouseRegion(
                        child: GestureDetector(
                          onTap: () {
                            if(!pageState.invoice.depositPaid && !pageState.invoice.invoicePaid) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      MouseRegion(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 16, right: 16),
                                            alignment: Alignment.topRight,
                                            child: Icon(Icons.close_sharp, color: Color(ColorConstants.getPrimaryWhite()), size: 32),
                                          ),
                                        ),
                                        cursor: SystemMouseCursors.click,
                                      ),
                                      DeviceType.getDeviceTypeByContext(context) != Type.Website ? SingleChildScrollView(
                                        child: PayNowPage(amount: pageState.invoice.depositAmount, type: PayNowPage.TYPE_RETAINER),
                                      ) : PayNowPage(amount: pageState.invoice.depositAmount, type: PayNowPage.TYPE_RETAINER)
                                    ],
                                  );
                                },
                              );
                            } else {
                              if(!pageState.invoice.invoicePaid) {
                                pageState.onMarkAsPaidDepositSelected(false);
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 116,
                            height: 48,
                            margin: EdgeInsets.only(bottom: 8, left: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color(!pageState.invoice.depositPaid && !pageState.invoice.invoicePaid ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: !pageState.invoice.depositPaid ? 'PAY NOW' : 'PAID',
                              color: Color(!pageState.invoice.depositPaid && !pageState.invoice.invoicePaid ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                              isBold: isHoveredPayDeposit,
                            ),
                          ),
                        ),
                        cursor:  !pageState.invoice.invoicePaid ? SystemMouseCursors.click : SystemMouseCursors.basic,
                        onHover: (event) {
                          if(!pageState.invoice.depositPaid && !pageState.invoice.invoicePaid) {
                            setState(() {
                              isHoveredPayDeposit = true;
                            });
                          }
                        },
                        onExit: (event) {
                          if(!pageState.invoice.depositPaid && !pageState.invoice.invoicePaid) {
                            setState(() {
                              isHoveredPayDeposit = false;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              width: 1080,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Balance Due',
                          isBold: true,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Due:  ' + (pageState.invoice.unpaidAmount != null
                              ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.invoice.dueDate)
                              : 'TBD'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.unpaidAmount),
                        ),
                      ),
                      MouseRegion(
                        child: GestureDetector(
                          onTap: () {
                            if(!pageState.invoice.invoicePaid) {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return DeviceType.getDeviceTypeByContext(
                                      context) != Type.Website
                                      ? SingleChildScrollView(
                                    child: PayNowPage(
                                        amount: pageState.invoice
                                            .unpaidAmount,
                                        type: PayNowPage.TYPE_BALANCE),
                                  )
                                      : PayNowPage(
                                      amount: pageState.invoice
                                          .unpaidAmount,
                                      type: PayNowPage.TYPE_BALANCE);
                                },
                              );
                            } else {
                              pageState.onMarkAsPaidSelected(false);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 116,
                            height: 48,
                            margin: EdgeInsets.only(bottom: 8, left: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color(!pageState.invoice.invoicePaid ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: !pageState.invoice.invoicePaid ? 'PAY NOW' : 'PAID',
                              color: Color(!pageState.invoice.invoicePaid ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                              isBold: isHoveredPayFull,
                            ),
                          ),
                        ),
                        cursor: SystemMouseCursors.click,
                        onHover: (event) {
                          setState(() {
                            isHoveredPayFull = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHoveredPayFull = false;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 48),
              alignment: Alignment.center,
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Price Breakdown',
                isBold: true,
              ),
            ),
            Container(
              width: 1080,
              height: 54,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(ColorConstants.getBlueLight())
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Services & Products',
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Amount',
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildLineItems(pageState),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
              width: 1080,
              height: 1,
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
            Container(
              width: 540,
              margin: EdgeInsets.only(left: 16, right: 16, top: 0),
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Subtotal',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.subtotal),
                    ),
                  ),
                ],
              ),
            ),
            pageState.invoice.discount > 0 ? Container(
              width: 540,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Discount',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '-' + TextFormatterUtil.formatDecimalCurrency(pageState.invoice.discount),
                    ),
                  ),
                ],
              ),
            ) : SizedBox(),
            pageState.invoice.salesTaxAmount > 0 ? Container(
              width: 540,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Sales tax',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '(' + pageState.invoice.salesTaxRate.toString() + '%) ' + TextFormatterUtil.formatDecimalCurrency(pageState.invoice.salesTaxAmount) ,
                    ),
                  ),
                ],
              ),
            ) : SizedBox(),
            Container(
              width: 540,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Total',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.total) ,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
              width: 1080,
              height: 1,
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
            Container(
              width: 540,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Retainer ' + (pageState.invoice.depositPaid ? '(Paid)' : '(Unpaid)'),
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: (pageState.invoice.depositPaid ? '-' : '') + TextFormatterUtil.formatDecimalCurrency(pageState.invoice.depositAmount),
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 540,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Balance Due',
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.unpaidAmount),
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 164,)
          ],
        ),
      ),
    );

  List<Widget> _buildLineItems(ClientPortalPageState pageState) {
    List<Widget> items = [];
    pageState.invoice.lineItems.forEach((lineItem) {
      items.add(Container(
        width: 1080,
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: EdgeInsets.only(left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: lineItem.itemName,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: TextFormatterUtil.formatDecimalCurrency(lineItem.itemPrice),
              ),
            ),
          ],
        ),
      ));
    });
    return items;
  }
}