import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_invoice_page/DueDateSelectionPage.dart';
import 'package:client_safe/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:client_safe/pages/new_invoice_page/JobSelectionForm.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/PriceBreakdownForm.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/KeyboardUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'LineItemWidget.dart';

class NewInvoiceDialog extends StatefulWidget {
  @override
  _NewInvoiceDialogState createState() {
    return _NewInvoiceDialogState();
  }
}

class _NewInvoiceDialogState extends State<NewInvoiceDialog> with AutomaticKeepAliveClientMixin {
  OverlayEntry overlayEntry;
  final int pageCount = 3;
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        appState.dispatch(ClearStateAction(appState.state.newInvoicePageState));
        appState.dispatch(
            FetchAllInvoiceJobsAction(appState.state.newInvoicePageState));
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 450.0,
              height: pageState.pageViewIndex == 2 ? 400.0 : 650.0,
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
                        color: Color(ColorConstants.getPrimaryColor()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        "Invoice 1000",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                        color: Color(ColorConstants.getPeachDark()),
                        onPressed: () {

                        },
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
                            maxHeight: pageState.pageViewIndex == 1
                                ? 196
                                : 440.0,
                          ),
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            pageSnapping: true,
                            children: <Widget>[
                              JobSelectionForm(),
                              PriceBreakdownForm(),
                              DueDateSelectionPage(),
                            ],
                          ),
                        ),
                        pageState.pageViewIndex == 1 ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 16.0, right: 16.0),
                              height: 164.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: pageState.lineItems.length,
                                itemBuilder: (context, index) {
                                  return LineItemWidget(
                                      pageState.lineItems.elementAt(index), index, pageState.lineItems.length, pageState.onLineItemDeleted);
                                },
                              ),
                            ),
                            Container(
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
                            ),
                            Container(
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
                                    fontSize: 16.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                        ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) : SizedBox(),
                        pageState.pageViewIndex == 1 ? Container(
                          margin: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          height: 1.0,
                          color: Color(
                              ColorConstants.getPrimaryBackgroundGrey()),
                        ) : SizedBox(),
                        pageState.pageViewIndex == 1 ? Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 0.0, top: 0.0),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 112.0),
                                child: Text(
                                  'Subtotal',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Color(
                                        ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ),
                              Text(
                                '\$' + pageState.total.toInt().toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(
                                      ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
                        ) : SizedBox(),
                        pageState.pageViewIndex == 1 ? Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 4.0),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 112.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'Deposit  ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w400,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      ),
                                    ),
                                    Text(
                                      (pageState.selectedJob.isDepositPaid()
                                          ? '(paid)'
                                          : '(unpaid)'),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                (pageState.selectedJob.isDepositPaid()
                                    ? '-'
                                    : '') + '\$' +
                                    pageState.depositValue.toInt().toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(
                                      pageState.selectedJob.isDepositPaid()
                                          ? ColorConstants.getPrimaryBlack()
                                          : ColorConstants
                                          .getPrimaryBackgroundGrey()),
                                ),
                              ),
                            ],
                          ),
                        ) : SizedBox(),
                        pageState.pageViewIndex == 1 ? _buildDiscountWidget(
                            pageState) : SizedBox(),
                        pageState.pageViewIndex == 1 ? Container(
                          margin: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 0.0),
                          height: 1.0,
                          color: Color(
                              ColorConstants.getPrimaryBackgroundGrey()),
                        ) : SizedBox(),
                        pageState.pageViewIndex == 1 ? Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 48.0, top: 16.0),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 112.0),
                                child: Text(
                                  'Balance Due',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Color(
                                        ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ),
                              Text(
                                '\$' +
                                    pageState.unpaidAmount.toInt().toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              onBackPressed(pageState);
                            },
                            child: Text(
                              pageState.pageViewIndex == 0 ? 'Cancel' : 'Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: Text(
                              pageState.pageViewIndex == pageCount - 1
                                  ? 'Save'
                                  : 'Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void onNextPressed(NewInvoicePageState pageState) {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount - 1) {
      switch (pageState.pageViewIndex) {
        case 0:
          if (pageState.selectedJob != null) canProgress = true;
          break;
        case 1:
          canProgress = true;
          break;
        case 2:
          canProgress = true;
          break;
        case 3:
          canProgress = true;
          break;
        default:
          canProgress = true;
          break;
      }

      if (canProgress) {
        pageState.onNextPressed();
        controller.animateToPage(pageState.pageViewIndex + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        if (MediaQuery
            .of(context)
            .viewInsets
            .bottom != 0) KeyboardUtil.closeKeyboard(context);
      }
    }
    if (pageState.pageViewIndex == pageCount - 1) {
      showSuccessAnimation();
      pageState.onSavePressed();
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneViewNewInvoice());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }


  void showSuccessAnimation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  void onBackPressed(NewInvoicePageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCancelPressed();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed();
      controller.animateToPage(pageState.pageViewIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }

  @override
  bool get wantKeepAlive => true;

  _buildDiscountWidget(NewInvoicePageState pageState) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              pageState.discountValue > 0.0 ?
              Container(
                margin: EdgeInsets.only(right: 4.0),
                child: GestureDetector(
                  onTap: () {
                    pageState.onDeleteDiscountSelected();
                  },
                  child: Text(
                    'X  ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                ),
              ) : SizedBox(),
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 112.0),
                child: Text(
                  'Discount',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
            ],
          ),
          pageState.discountValue == 0.0 ?
          Container(
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                borderRadius: BorderRadius.circular(24.0)
            ),
            width: 64.0,
            height: 28.0,
            child: FlatButton(
              onPressed: () {
                UserOptionsUtil.showNewDiscountDialog(context);
              },
              child: Text(
                'Add',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ) : SizedBox(),
          pageState.discountValue > 0.0 ? Text(
            (pageState.discountValue.toInt() > 0 ? '-' : '') + '\$' +
                (pageState.discountValue.toInt().toString()),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
              color: Color(pageState.discountValue.toInt() > 0 ? ColorConstants
                  .getPrimaryBlack() : ColorConstants
                  .getPrimaryBackgroundGrey()),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}