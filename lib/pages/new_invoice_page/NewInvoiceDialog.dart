import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/BalanceDueWidget.dart';
import 'package:dandylight/pages/new_invoice_page/DepositRowWidget.dart';
import 'package:dandylight/pages/new_invoice_page/DiscountRowWidget.dart';
import 'package:dandylight/pages/new_invoice_page/DueDateSelectionPage.dart';
import 'package:dandylight/pages/new_invoice_page/GrayDividerWidget.dart';
import 'package:dandylight/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:dandylight/pages/new_invoice_page/InvoiceReviewPage.dart';
import 'package:dandylight/pages/new_invoice_page/JobSelectionForm.dart';
import 'package:dandylight/pages/new_invoice_page/LineItemListWidget.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_invoice_page/PriceBreakdownForm.dart';
import 'package:dandylight/pages/new_invoice_page/SubtotalRowWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/Job.dart';
import '../../models/JobStage.dart';

class NewInvoiceDialog extends StatefulWidget {
  final Function onSendInvoiceSelected;

  NewInvoiceDialog(this.onSendInvoiceSelected);

  @override
  _NewInvoiceDialogState createState() {
    return _NewInvoiceDialogState(onSendInvoiceSelected);
  }
}

class _NewInvoiceDialogState extends State<NewInvoiceDialog> with AutomaticKeepAliveClientMixin {
  Function onSendInvoiceSelected;

  _NewInvoiceDialogState(this.onSendInvoiceSelected);

  OverlayEntry overlayEntry;
  final int pageCount = 4;
  bool hasJumpToBeenCalled = false;
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        if(appState.state.newInvoicePageState.shouldClear) appState.dispatch(ClearStateAction(appState.state.newInvoicePageState));
        appState.dispatch(FetchAllInvoiceJobsAction(appState.state.newInvoicePageState));
      },
      onDidChange: (prev, pageState) {
        if(!pageState.shouldClear && !hasJumpToBeenCalled) {
          controller.jumpToPage(1);
          hasJumpToBeenCalled = true;
        }
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
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
                          "Invoice " + pageState.invoiceNumber.toString(),
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
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            pageSnapping: true,
                            children: <Widget>[
                              JobSelectionForm(),
                              PriceBreakdownForm(),
                              DueDateSelectionPage(),
                              InvoiceReviewPage(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                onBackPressed(pageState);
                              },
                              child: Text(
                                pageState.pageViewIndex == 0 || ((pageState.pageViewIndex == 1) && hasJumpToBeenCalled) || ((pageState.pageViewIndex == 1) && (!pageState.shouldClear && !hasJumpToBeenCalled)) ? 'Cancel' : 'Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                onNextPressed(pageState);
                              },
                              child: Text(
                                pageState.pageViewIndex == pageCount - 1
                                    ? 'Save'
                                    : 'Next',
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
          pageState.generateInvoicePdf();
          break;
        case 3:
          canProgress = true;
          break;
        case 4:
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
      showSuccessAnimation(
        context,
        pageState.invoiceNumber,
      );
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


  void showSuccessAnimation(BuildContext context, int invoiceId) {
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
            callback: (String unused) {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
              UserOptionsUtil.showSendInvoicePromptDialog(context, invoiceId, onSendInvoiceSelected);
            },
          ),
        );
      },
    );
  }

  void onBackPressed(NewInvoicePageState pageState) {
    if (pageState.pageViewIndex == 0 || ((pageState.pageViewIndex == 1) && hasJumpToBeenCalled) || ((pageState.pageViewIndex == 1) && (!pageState.shouldClear && !hasJumpToBeenCalled))) {
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
}