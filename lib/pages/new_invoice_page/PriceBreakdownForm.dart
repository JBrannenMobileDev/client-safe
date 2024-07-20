import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/InputDoneView.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../widgets/TextDandyLight.dart';
import 'BalanceDueWidget.dart';
import 'DepositRowWidget.dart';
import 'DiscountRowWidget.dart';
import 'GrayDividerWidget.dart';
import 'LineItemListWidget.dart';
import 'SalesTaxRowWidget.dart';
import 'SubtotalRowWidget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class PriceBreakdownForm extends StatefulWidget {

  @override
  _PriceBreakdownFormState createState() {
    return _PriceBreakdownFormState();
  }
}

class _PriceBreakdownFormState extends State<PriceBreakdownForm> with AutomaticKeepAliveClientMixin {
  OverlayEntry? overlayEntry;
  final FocusNode flatRateInputFocusNode = FocusNode();
  var flatRateTextController = TextEditingController(text: '\$');
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if(flatRateTextController.text.isEmpty) flatRateTextController = TextEditingController(text: '\$');

    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {

        if (appState.state.newInvoicePageState!.selectedJob?.sessionType != null) {
          flatRateTextController = TextEditingController(text: '\$${appState.state.newInvoicePageState!.selectedJob!.sessionType!.totalCost.toInt()}');
        }

        flatRateInputFocusNode.addListener(() {
          bool hasFocus = overlayEntry != null;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        }
        );
      },
      onDidChange: (prev, pageState) {
        flatRateTextController.text = pageState.flatRateText!.isEmpty ? '\$' : '\$${double.parse(pageState.flatRateText!.replaceFirst(r'$', '')).toInt()}';
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
      Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Price Breakdown',
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 16.0, top: 24.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Line Items',
                  textAlign: TextAlign.start,
                  color: Color(
                      ColorConstants.getPrimaryBlack()),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LineItemListWidget(pageState, false),
                  GrayDividerWidget(),
                  SubtotalRowWidget(pageState),
                  DiscountRowWidget(pageState),
                  SalesTaxRowWidget(),
                  GrayDividerWidget(),
                  (pageState.selectedJob?.sessionType?.deposit ?? 0) > 0 ? DepositRowWidget() : SizedBox(),
                  BalanceDueWidget(pageState),
                ],
              )
            ],
          ),
    );
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
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

  @override
  bool get wantKeepAlive => true;
}