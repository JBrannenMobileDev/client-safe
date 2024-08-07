import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/DueDateSelectionPage.dart';
import 'package:dandylight/pages/new_invoice_page/InputDoneView.dart';
import 'package:dandylight/pages/new_invoice_page/JobSelectionForm.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_invoice_page/PriceBreakdownForm.dart';
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
import '../../widgets/TextDandyLight.dart';

class NewInvoiceDialog extends StatefulWidget {
  final Function? onSendInvoiceSelected;
  final Job? job;

  NewInvoiceDialog({this.onSendInvoiceSelected, this.job});

  @override
  _NewInvoiceDialogState createState() {
    return _NewInvoiceDialogState(onSendInvoiceSelected, job);
  }
}

class _NewInvoiceDialogState extends State<NewInvoiceDialog> with AutomaticKeepAliveClientMixin {
  Function? onSendInvoiceSelected;
  Job? job;

  _NewInvoiceDialogState(this.onSendInvoiceSelected, this.job);

  OverlayEntry? overlayEntry;
  final int pageCount = 3;
  bool hasJumpToBeenCalled = false;
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) async {
        if(job != null) {
          appState.dispatch(ClearNewInvoiceStateAction(appState.state.newInvoicePageState));
          appState.dispatch(SaveSelectedJobAction(appState.state.newInvoicePageState, job));
        } else {
          appState.dispatch(FetchAllInvoiceJobsAction(appState.state.newInvoicePageState));
        }
      },
      onDidChange: (prev, pageState) {
        if(job != null && !hasJumpToBeenCalled) {
          controller.jumpToPage(1);
          hasJumpToBeenCalled = true;
        }
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Dialog(
            insetPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            backgroundColor: Colors.transparent,
            child: Container(
              width: 450.0,
              height: 708.0,
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
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Invoice " + pageState.invoiceNumber.toString(),
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
                            maxHeight: 604.0,
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                style: Styles.getButtonStyle(),
                                onPressed: () {
                                  onBackPressed(pageState);
                                },
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.pageViewIndex == 0 || ((pageState.pageViewIndex == 1) && hasJumpToBeenCalled) || ((pageState.pageViewIndex == 1) && (job != null && !hasJumpToBeenCalled)) ? 'Cancel' : 'Back',
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              TextButton(
                                style: Styles.getButtonStyle(),
                                onPressed: () {
                                  onNextPressed(pageState);
                                },
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.pageViewIndex == pageCount - 1
                                      ? 'Save'
                                      : 'Next',
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
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
    print('page index = ${pageState.pageViewIndex}');
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
          pageState.generateInvoicePdf!();
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
        pageState.onNextPressed!();
        controller.animateToPage(pageState.pageViewIndex! + 1,
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
        pageState.invoiceNumber!,
        pageState
      );
      pageState.onSavePressed!();
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
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }


  void showSuccessAnimation(BuildContext context, int invoiceId, NewInvoicePageState pageState) {
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
              UserOptionsUtil.showSendInvoicePromptDialog(context, invoiceId, pageState.onInvoiceSent!, pageState.selectedJob!);
            },
          ),
        );
      },
    );
  }

  void onBackPressed(NewInvoicePageState pageState) {
    if (pageState.pageViewIndex == 0 || ((pageState.pageViewIndex == 1) && hasJumpToBeenCalled) || ((pageState.pageViewIndex == 1) && (job != null && !hasJumpToBeenCalled))) {
      pageState.onCancelPressed!();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed!();
      controller.animateToPage(pageState.pageViewIndex! - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }

  @override
  bool get wantKeepAlive => true;
}