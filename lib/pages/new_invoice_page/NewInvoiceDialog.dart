import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:client_safe/pages/new_invoice_page/JobSelectionForm.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:client_safe/pages/new_invoice_page/PriceBreakdownForm.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/KeyboardUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewInvoiceDialog extends StatefulWidget {
  @override
  _NewInvoiceDialogState createState() {
    return _NewInvoiceDialogState();
  }
}

class _NewInvoiceDialogState extends State<NewInvoiceDialog> with AutomaticKeepAliveClientMixin {
  final FocusNode fixedDiscountFocusNode = new FocusNode();
  final FocusNode percentageDiscountFocusNode = new FocusNode();
  OverlayEntry overlayEntry;
  var fixedTextController = TextEditingController(text: '\$');
  var percentageTextController = TextEditingController(text: '%');
  final int pageCount = 2;
  final controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(fixedTextController.text.length == 0) fixedTextController = TextEditingController(text: '\$');
    if(percentageTextController.text.length == 0) percentageTextController = TextEditingController(text: '%');
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        appState.dispatch(ClearStateAction(appState.state.newInvoicePageState));
        appState.dispatch(FetchAllInvoiceJobsAction(appState.state.newInvoicePageState));

        fixedDiscountFocusNode.addListener(() {

          bool hasFocus = fixedDiscountFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        percentageDiscountFocusNode.addListener(() {

          bool hasFocus = percentageDiscountFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 550.0,
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Text(
                          "Invoice 1000",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Raleway',
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
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: pageState.pageViewIndex > 0 ? 196 :440.0,
                          ),
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            pageSnapping: true,
                            children: <Widget>[
                              JobSelectionForm(),
                              PriceBreakdownForm(),
                            ],
                          ),
                        ),
                        pageState.pageViewIndex > 0 ?  _buildSingleItemWidget(pageState) : SizedBox(),
                        pageState.pageViewIndex > 0 ? Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              Text(
                                '\$' + pageState.total.toInt().toString(),
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
                        pageState.pageViewIndex > 0 ? Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Deposit  ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w400,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Text(
                                    (pageState.selectedJob.isDepositPaid() ? '(paid)' : '(unpaid)'),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                (pageState.selectedJob.isDepositPaid() ? '-' : '') + '\$' + pageState.depositValue.toInt().toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(pageState.selectedJob.isDepositPaid() ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                              ),
                            ],
                          ),
                        ) : SizedBox(),
                        pageState.pageViewIndex > 0 ?  _buildDiscountWidget(pageState) : SizedBox(),
                        pageState.pageViewIndex > 0 ? Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0),
                          height: 1.0,
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        ) : SizedBox(),
                        pageState.pageViewIndex > 0 ? Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 48.0, top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Remaining balance',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              Text(
                                '\$' + pageState.unpaidAmount.toInt().toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                              ),
                            ],
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 64.0,
                      color: Colors.white,
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
                              pageState.pageViewIndex == pageCount-1 ? 'Save' : 'Next',
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
    if (pageState.pageViewIndex != pageCount-1) {
      switch (pageState.pageViewIndex) {
        case 0:
          if(pageState.selectedJob != null) canProgress = true;
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
        if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);
      }
    }
    if (pageState.pageViewIndex == pageCount-1) {
      showSuccessAnimation();
      pageState.onSavePressed();
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
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


  void showSuccessAnimation(){
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
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
      child: pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_TYPE_SELECTION
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                borderRadius: BorderRadius.circular(24.0)
            ),
            width: 116.0,
            height: 28.0,
            child: FlatButton(
              onPressed: () {
                pageState.onDiscountTypeSelected(Invoice.DISCOUNT_TYPE_FIXED_AMOUNT);
              },
              child: Text(
                'Fixed',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ),
          Text(
            'Or',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                borderRadius: BorderRadius.circular(24.0)
            ),
            width: 116.0,
            height: 28.0,
            child: FlatButton(
              onPressed: () {
                pageState.onDiscountTypeSelected(Invoice.DISCOUNT_TYPE_PERCENTAGE);
              },
              child: Text(
                'Percent',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ),
        ],
      ) : pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_AMOUNT_SELECTION ?
      pageState.discountType == Invoice.DISCOUNT_TYPE_FIXED_AMOUNT ? NewInvoiceTextField(
        controller: fixedTextController,
        hintText: "\$",
        inputType: TextInputType.number,
        height: 60.0,
        onTextInputChanged: pageState.onFixedDiscountTextChanged,
        capitalization: TextCapitalization.none,
        keyboardAction: TextInputAction.done,
        labelText: 'Fixed discount',
      ) :
      NewInvoiceTextField(
        controller: percentageTextController,
        hintText: "%",
        inputType: TextInputType.number,
        height: 60.0,
        onTextInputChanged: pageState.onPercentageDiscountTextChanged,
        capitalization: TextCapitalization.none,
        keyboardAction: TextInputAction.done,
        labelText: 'Percentage discount',
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 0.0),
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
              pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_NO_STAGE ?
              Container(
                margin: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryColor()),
                    borderRadius: BorderRadius.circular(24.0)
                ),
                width: 64.0,
                height: 28.0,
                child: FlatButton(
                  onPressed: () {
                    pageState.onAddDiscountPressed();
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
              pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_STAGE_ADDED ?
              Container(
                margin: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPeachDark()),
                    borderRadius: BorderRadius.circular(24.0)
                ),
                width: 84.0,
                height: 28.0,
                child: FlatButton(
                  onPressed: () {
                    pageState.onDeleteDiscountPressed();
                    fixedTextController.text = '\$';
                    percentageTextController.text = '\%';
                  },
                  child: Text(
                    'Delete',
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
            ],
          ),
          Text(
              (pageState.discountValue.toInt() > 0 ? '-' : '') + '\$' + (pageState.discountValue.toInt().toString()),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
              color: Color(pageState.discountValue.toInt() > 0 ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryBackgroundGrey()),
            ),
          ),
        ],
      ),
    );
  }

  _buildSingleItemWidget(NewInvoicePageState pageState) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
      child: pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_TYPE_SELECTION
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                borderRadius: BorderRadius.circular(24.0)
            ),
            width: 116.0,
            height: 28.0,
            child: FlatButton(
              onPressed: () {
                pageState.onDiscountTypeSelected(Invoice.DISCOUNT_TYPE_FIXED_AMOUNT);
              },
              child: Text(
                'Fixed',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ),
          Text(
            'Or',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                borderRadius: BorderRadius.circular(24.0)
            ),
            width: 116.0,
            height: 28.0,
            child: FlatButton(
              onPressed: () {
                pageState.onDiscountTypeSelected(Invoice.DISCOUNT_TYPE_PERCENTAGE);
              },
              child: Text(
                'Percent',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ),
        ],
      ) : pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_AMOUNT_SELECTION ?
      pageState.discountType == Invoice.DISCOUNT_TYPE_FIXED_AMOUNT ? NewInvoiceTextField(
        controller: fixedTextController,
        hintText: "\$",
        inputType: TextInputType.number,
        height: 60.0,
        onTextInputChanged: pageState.onFixedDiscountTextChanged,
        capitalization: TextCapitalization.none,
        keyboardAction: TextInputAction.done,
        labelText: 'Fixed discount',
      ) :
      NewInvoiceTextField(
        controller: percentageTextController,
        hintText: "%",
        inputType: TextInputType.number,
        height: 60.0,
        onTextInputChanged: pageState.onPercentageDiscountTextChanged,
        capitalization: TextCapitalization.none,
        keyboardAction: TextInputAction.done,
        labelText: 'Percentage discount',
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 0.0),
                child: Text(
                  'Line Item',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
              pageState.discountStage == NewInvoicePageState.DISCOUNT_STAGE_NO_STAGE ?
              Container(
                margin: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryColor()),
                    borderRadius: BorderRadius.circular(24.0)
                ),
                width: 64.0,
                height: 28.0,
                child: FlatButton(
                  onPressed: () {
                    pageState.onAddDiscountPressed();
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
            ],
          ),
        ],
      ),
    );
  }
}
