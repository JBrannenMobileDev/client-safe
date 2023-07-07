import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/web/pages/invoicePage/PayNowPage.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
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
                      onTap: () {

                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 116,
                        height: 48,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(ColorConstants.getPeachDark())
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              child: Image.asset("images/icons/download.png", color: Color(ColorConstants.getPrimaryWhite()),),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'PDF',
                              color: Color(ColorConstants.getPrimaryWhite()),
                              isBold: isHoveredDownloadPDF,
                            ),
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
                  Container(
                    alignment: Alignment.topCenter,
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      textAlign: TextAlign.center,
                      text: 'Deposit - DUE TODAY',
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: '\150.00',
                        ),
                      ),
                      MouseRegion(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeviceType.getDeviceTypeByContext(context) != Type.Website ? SingleChildScrollView(
                                  child: PayNowPage(amount: 150.00),
                                ) : PayNowPage(amount: 150.00);
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
                              text: 'PAY',
                              color: Color(ColorConstants.getPrimaryWhite()),
                              isBold: isHoveredPayDeposit,
                            ),
                          ),
                        ),
                        cursor: SystemMouseCursors.click,
                        onHover: (event) {
                          setState(() {
                            isHoveredPayDeposit = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHoveredPayDeposit = false;
                          });
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
                  Container(
                    alignment: Alignment.topCenter,
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      textAlign: TextAlign.center,
                      text: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 'Full Payment - Due July 22, 2023' : 'Payment - Due 6/22/23',
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: '\$338.00',
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
                                  child: PayNowPage(amount: 338.00),
                                ) : PayNowPage(amount: 338.00);
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
                              text: 'PAY',
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
            DividerWidget(width: 1080),
            Container(
              margin: EdgeInsets.only(right: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Invoice Id: 1000',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Jason Bent',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '(951)295-0348',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'jbent@gmail.com',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1080,
              height: 54,
              margin: EdgeInsets.only(left: 16, right: 16, top: 32),
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
                      text: 'Deposit (paid)',
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