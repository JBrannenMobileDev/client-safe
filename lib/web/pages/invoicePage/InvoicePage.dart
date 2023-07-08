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
import '../../../widgets/DividerWidget.dart';
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
                      onTap: () {},
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
                      pageState.proposal.invoice.depositPaid ? Container(
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
                          text: 'Due:  ' + (pageState.proposal.invoice.depositDueDate != null
                              ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.proposal.invoice.depositDueDate)
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
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.proposal.invoice.depositAmount),
                        ),
                      ),
                      MouseRegion(
                        child: GestureDetector(
                          onTap: () {
                            if(!pageState.proposal.invoice.depositPaid) {
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
                                        child: PayNowPage(amount: pageState.proposal.invoice.depositAmount, type: PayNowPage.TYPE_RETAINER),
                                      ) : PayNowPage(amount: pageState.proposal.invoice.depositAmount, type: PayNowPage.TYPE_RETAINER)
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 116,
                            height: 48,
                            margin: EdgeInsets.only(bottom: 8, left: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color(!pageState.proposal.invoice.depositPaid ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: !pageState.proposal.invoice.depositPaid ? 'PAY NOW' : 'PAID',
                              color: Color(ColorConstants.getPrimaryWhite()),
                              isBold: isHoveredPayDeposit,
                            ),
                          ),
                        ),
                        cursor: SystemMouseCursors.click,
                        onHover: (event) {
                          if(!pageState.proposal.invoice.depositPaid) {
                            setState(() {
                              isHoveredPayDeposit = true;
                            });
                          }
                        },
                        onExit: (event) {
                          if(!pageState.proposal.invoice.depositPaid) {
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
                          text: 'Due:  ' + (pageState.proposal.invoice.unpaidAmount != null
                              ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.proposal.invoice.dueDate)
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
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.proposal.invoice.unpaidAmount),
                        ),
                      ),
                      MouseRegion(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return DeviceType.getDeviceTypeByContext(context) != Type.Website ? SingleChildScrollView(
                                  child: PayNowPage(amount: pageState.proposal.invoice.unpaidAmount, type: PayNowPage.TYPE_BALANCE),
                                ) : PayNowPage(amount: pageState.proposal.invoice.unpaidAmount, type: PayNowPage.TYPE_BALANCE);
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 116,
                            height: 48,
                            margin: EdgeInsets.only(bottom: 8, left: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color(ColorConstants.getPeachDark())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'PAY NOW',
                              color: Color(ColorConstants.getPrimaryWhite()),
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
                      text: 'Line Items',
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
            Container(
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
                      text: 'Standard 1 hr',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '\$450.00',
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
                      text: 'Second Location',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '\$50.00',
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
                      text: '\$500.00',
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
                      text: 'Retainer (paid)',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '-\$150.00',
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
                      text: 'Discount',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '-\$50.00',
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
                      text: 'Sales tax',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '\$38.00',
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
                      text: 'Balance Due',
                      isBold: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '\$338.00',
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
}