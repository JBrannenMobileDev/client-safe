import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpenseCostTextField.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../widgets/TextDandyLight.dart';


class NewSingleExpenseCost extends StatefulWidget {
  @override
  _NewSingleExpenseCost createState() {
    return _NewSingleExpenseCost();
  }
}

class _NewSingleExpenseCost extends State<NewSingleExpenseCost> with AutomaticKeepAliveClientMixin {
  final costTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '.', thousandSeparator: ',');
  OverlayEntry overlayEntry;
  final FocusNode costFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewSingleExpensePageState>(
      onInit: (store) {
          costTextController.updateValue(store.state.newSingleExpensePageState.expenseCost);
          KeyboardVisibilityNotification().addNewListener(
              onShow: () {
                showOverlay(context);
              },
              onHide: () {
                removeOverlay();
              }
          );

          costFocusNode.addListener(() {
            bool hasFocus = costFocusNode.hasFocus;
            if (hasFocus)
              showOverlay(context);
            else
              removeOverlay();
          });
      },
      converter: (store) => NewSingleExpensePageState.fromStore(store),
      builder: (BuildContext context, NewSingleExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 48.0, top: 16.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Enter the total cost of this expense.',
                textAlign: TextAlign.start,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            NewSingleExpenseCostTextField(
                costTextController,
                "\$ 0.0",
                TextInputType.number,
                84.0,
                pageState.onCostChanged,
                null,
                TextInputAction.done,
                costFocusNode,
                null,
                TextCapitalization.none,
                null),
          ],
        ),
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
