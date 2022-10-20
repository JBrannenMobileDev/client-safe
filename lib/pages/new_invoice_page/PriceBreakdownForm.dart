import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/RateTypeSelection.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../models/Job.dart';
import '../../models/JobStage.dart';
import 'BalanceDueWidget.dart';
import 'DepositRowWidget.dart';
import 'DiscountRowWidget.dart';
import 'GrayDividerWidget.dart';
import 'LineItemListWidget.dart';
import 'SalesTaxRowWidget.dart';
import 'SubtotalRowWidget.dart';

class PriceBreakdownForm extends StatefulWidget {

  @override
  _PriceBreakdownFormState createState() {
    return _PriceBreakdownFormState();
  }
}

class _PriceBreakdownFormState extends State<PriceBreakdownForm> with AutomaticKeepAliveClientMixin {
  OverlayEntry overlayEntry;
  final FocusNode flatRateInputFocusNode = FocusNode();
  var flatRateTextController = TextEditingController(text: '\$');

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if(flatRateTextController.text.length == 0) flatRateTextController = TextEditingController(text: '\$');

    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {

        if (appState.state.newInvoicePageState.selectedJob?.priceProfile != null) {
          flatRateTextController = TextEditingController(text: '\$' + appState.state.newInvoicePageState.selectedJob.priceProfile
              .flatRate.toInt().toString());
        }

        KeyboardVisibilityNotification().addNewListener(
            onShow: () {
              showOverlay(context);
            },
            onHide: () {
              removeOverlay();
            }
        );

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
        flatRateTextController.text = pageState.flatRateText.length == 0 ? '\$' : '\$' + double.parse(pageState.flatRateText.replaceFirst(r'$', '')).toInt().toString();
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
      Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Price Breakdown',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 16.0, top: 24.0),
                child: Text(
                  'Line Items',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w800,
                    color: Color(
                        ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LineItemListWidget(pageState, false),
                  GrayDividerWidget(),
                  SubtotalRowWidget(pageState),
                  Job.containsStage(pageState.selectedJob.type.stages, JobStage.STAGE_5_DEPOSIT_RECEIVED) ? DepositRowWidget() : SizedBox(),
                  DiscountRowWidget(pageState),
                  SalesTaxRowWidget(),
                  GrayDividerWidget(),
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

  @override
  bool get wantKeepAlive => true;
}