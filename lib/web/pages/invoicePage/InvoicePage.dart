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
        width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 32, bottom: 48),
                  child: TextDandyLight(
                    type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
                    fontFamily: pageState.profile.selectedFontTheme.mainFont,
                    text: 'Invoice',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32, right: 16),
                  alignment: Alignment.centerRight,
                  width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
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
                            color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor)
                        ),
                        child: Row(
                          mainAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              child: Image.asset(
                                "images/download_white.png",
                              ),
                            ),
                            DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'PDF',
                              color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor),
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
            pageState.invoice.depositAmount > 0 ? Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                          text: 'Retainer',
                          isBold: true,
                        ),
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              fontFamily: pageState.profile.selectedFontTheme.mainFont,
                              text: 'Retainer - ',
                              isBold: true,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              textAlign: TextAlign.center,
                              text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.depositAmount),
                            ),
                          ),
                        ],
                      ),
                      pageState.invoice.depositPaid ? Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          text: 'PAID',
                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                        ),
                      ) : Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                          text: 'Due:  ' + (pageState.invoice.depositDueDate != null
                              ? DateFormat(
                                DeviceType.getDeviceTypeByContext(context) == Type.Website ? 'EEE, MMMM dd, yyyy' : 'mm/dd/yy'
                              ).format(pageState.invoice.depositDueDate)
                              : 'TBD'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.depositAmount),
                        ),
                      ) : SizedBox(),
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
                            margin: EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: !pageState.invoice.depositPaid && !pageState.invoice.invoicePaid ? ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor) : Color( ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              fontFamily: pageState.profile.selectedFontTheme.mainFont,
                              text: !pageState.invoice.depositPaid ? 'PAY NOW' : 'PAID',
                              color: !pageState.invoice.depositPaid && !pageState.invoice.invoicePaid ? ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor) : Color(ColorConstants.getPrimaryBlack()),
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
            ) : SizedBox(),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Balance Due',
                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                          isBold: true,
                        ),
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Balance Due - ',
                              fontFamily: pageState.profile.selectedFontTheme.mainFont,
                              isBold: true,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              textAlign: TextAlign.center,
                              text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.invoicePaid ? pageState.invoice.balancePaidAmount : pageState.invoice.unpaidAmount),
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          fontFamily: pageState.profile.selectedFontTheme.mainFont,
                          text: 'Due:  ' + (pageState.invoice.unpaidAmount != null
                              ? DateFormat(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 'EEE, MMMM dd, yyyy' : 'mm/dd/yy').format(pageState.invoice.dueDate)
                              : 'TBD'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.invoicePaid ? pageState.invoice.balancePaidAmount : pageState.invoice.unpaidAmount),
                        ),
                      ) : SizedBox(),
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
                            margin: EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: !pageState.invoice.invoicePaid ? ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor) : Color(ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: !pageState.invoice.invoicePaid ? 'PAY NOW' : 'PAID',
                              fontFamily: pageState.profile.selectedFontTheme.mainFont,
                              color: !pageState.invoice.invoicePaid ? ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor) : Color(ColorConstants.getPrimaryBlack()),
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
                fontFamily: pageState.profile.selectedFontTheme.mainFont,
                isBold: true,
              ),
            ),
            Container(
              width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
              height: 54,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.only(left: 32, right: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(ColorConstants.getPrimaryBackgroundGrey())
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      text: 'Services & Products',
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
              width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
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
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      text: 'Subtotal',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Discount',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Sales tax',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Total',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: TextFormatterUtil.formatDecimalCurrency(pageState.invoice.total) ,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
              width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
              height: 1,
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
            pageState.invoice.depositAmount > 0 ? Container(
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
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Retainer ' + (pageState.invoice.depositPaid ? '(Paid)' : '(Unpaid)'),
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: (pageState.invoice.depositPaid ? '-' : '') + TextFormatterUtil.formatDecimalCurrency(pageState.invoice.depositAmount),
                      isBold: true,
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
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Balance Due',
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
        width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: EdgeInsets.only(left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: TextDandyLight(
                fontFamily: pageState.profile.selectedFontTheme.mainFont,
                type: TextDandyLight.MEDIUM_TEXT,
                text: lineItem.itemName,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextDandyLight(
                fontFamily: pageState.profile.selectedFontTheme.mainFont,
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