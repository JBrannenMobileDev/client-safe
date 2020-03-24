import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class PriceBreakdownForm extends StatefulWidget {
  static const String SELECTOR_TYPE_FLAT_RATE = "Flat rate";
  static const String SELECTOR_TYPE_HOURLY = "Hourly";
  static const String SELECTOR_TYPE_QUANTITY = "Quantity";

  @override
  _PriceBreakdownFormState createState() {
    return _PriceBreakdownFormState();
  }
}

class _PriceBreakdownFormState extends State<PriceBreakdownForm> with AutomaticKeepAliveClientMixin {
  OverlayEntry overlayEntry;
  final FocusNode flatRateInputFocusNode = FocusNode();
  final FocusNode hourlyRateInputFocusNode = FocusNode();
  final FocusNode itemRateInputFocusNode = FocusNode();
  final FocusNode itemQuantityFocusNode = FocusNode();
  final FocusNode hourlyQuantityFocusNode = FocusNode();
  var flatRateTextController = TextEditingController(text: '\$');
  var hourlyRateTextController = TextEditingController(text: '\$');
  var hourlyQuantityTextController = TextEditingController(text: '1');
  var quantityRateTextController = TextEditingController(text: '\$');
  var quantityQuantityTextController = TextEditingController(text: '1');
  int selectorIndex = 0;
  Map<int, Widget> breakdownTypes;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    breakdownTypes = <int, Widget>{
      0: Text(PriceBreakdownForm.SELECTOR_TYPE_FLAT_RATE,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      1: Text(PriceBreakdownForm.SELECTOR_TYPE_HOURLY,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      2: Text(PriceBreakdownForm.SELECTOR_TYPE_QUANTITY,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(selectorIndex == 2
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };



    if(flatRateTextController.text.length == 0) flatRateTextController = TextEditingController(text: '\$');
    if(hourlyRateTextController.text.length == 0) hourlyRateTextController = TextEditingController(text: '\$');
    if(quantityRateTextController.text.length == 0) quantityRateTextController = TextEditingController(text: '\$');
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        if(appState.state.newInvoicePageState.selectedJob?.priceProfile != null){
          flatRateTextController = TextEditingController(text: '\$' + appState.state.newInvoicePageState.selectedJob.priceProfile.flatRate.toInt().toString());
        }
        if(appState.state.newInvoicePageState.selectedJob?.priceProfile != null){
          hourlyRateTextController = TextEditingController(text: '\$' + (appState.state.newInvoicePageState.selectedJob.priceProfile.hourlyRate.toInt() > 0 ? appState.state.newInvoicePageState.selectedJob.priceProfile.hourlyRate.toInt().toString() : ''));
        }
        if(appState.state.newInvoicePageState.selectedJob?.priceProfile != null){
          quantityRateTextController = TextEditingController(text: '\$' + (appState.state.newInvoicePageState.selectedJob.priceProfile.itemRate.toInt() > 0 ? appState.state.newInvoicePageState.selectedJob.priceProfile.itemRate.toInt().toString() : ''));
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

          bool hasFocus = flatRateInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        hourlyRateInputFocusNode.addListener(() {

          bool hasFocus = hourlyRateInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        itemRateInputFocusNode.addListener(() {

          bool hasFocus = itemRateInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        itemQuantityFocusNode.addListener(() {

          bool hasFocus = itemQuantityFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        hourlyQuantityFocusNode.addListener(() {

          bool hasFocus = hourlyQuantityFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
      Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Price Breakdown',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
              Container(
                width: 300.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  thumbColor: Color(ColorConstants.getPrimaryColor()),
                  children: breakdownTypes,
                  onValueChanged: (int filterTypeIndex) {
                    setState(() {
                      selectorIndex = filterTypeIndex;
                    });
                    pageState.onFilterChanged(
                        filterTypeIndex == 0 ? PriceBreakdownForm
                            .SELECTOR_TYPE_FLAT_RATE : filterTypeIndex == 1
                            ? PriceBreakdownForm.SELECTOR_TYPE_HOURLY
                            : PriceBreakdownForm.SELECTOR_TYPE_QUANTITY);
                  },
                  groupValue: selectorIndex,
                ),
              ),
              selectorIndex == 0 ? Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: NewInvoiceTextField(
                  focusNode: flatRateInputFocusNode,
                  controller: flatRateTextController,
                  hintText: "\$",
                  inputType: TextInputType.number,
                  height: 60.0,
                  onTextInputChanged: pageState.onFlatRateTextChanged,
                  capitalization: TextCapitalization.none,
                  keyboardAction: TextInputAction.done,
                  labelText: 'Rate',
                ),
              ) : selectorIndex == 1 ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 112.0,
                        margin: EdgeInsets.only(left: 15.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          focusNode: hourlyRateInputFocusNode,
                          controller: hourlyRateTextController,
                          hintText: "\$",
                          inputType: TextInputType.number,
                          height: 60.0,
                          onTextInputChanged: pageState.onHourlyRateTextChanged,
                          capitalization: TextCapitalization.none,
                          keyboardAction: TextInputAction.done,
                          labelText: 'Rate',
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: IconButton(
                          icon: Icon(
                              Icons.close,
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          tooltip: 'delete',
                          onPressed: null,
                        ),
                      ),
                      Container(
                        width: 112.0,
                        margin: EdgeInsets.only(right: 15.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          focusNode: hourlyQuantityFocusNode,
                          controller: hourlyQuantityTextController,
                          hintText: "1",
                          inputType: TextInputType.number,
                          height: 60.0,
                          onTextInputChanged: pageState.onHourlyQuantityTextChanged,
                          capitalization: TextCapitalization.none,
                          keyboardAction: TextInputAction.done,
                          labelText: 'Hours',
                        ),
                      ),
                    ],
                  ):
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 112.0,
                    margin: EdgeInsets.only(left: 15.0),
                    child: NewInvoiceTextField(
                      focusNode: itemRateInputFocusNode,
                      controller: quantityRateTextController,
                      hintText: "\$",
                      inputType: TextInputType.number,
                      height: 60.0,
                      onTextInputChanged: pageState.onItemRateTextChanged,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                      labelText: 'Rate',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                          Icons.close,
                          color: Color(ColorConstants.getPrimaryBlack())
                      ),
                      tooltip: 'delete',
                      onPressed: null,
                    ),
                  ),
                  Container(
                    width: 112.0,
                    margin: EdgeInsets.only(right: 15.0),
                    child: NewInvoiceTextField(
                      focusNode: itemQuantityFocusNode,
                      controller: quantityQuantityTextController,
                      hintText: "1",
                      inputType: TextInputType.number,
                      height: 60.0,
                      onTextInputChanged: pageState.onItemQuantityTextChanged,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                      labelText: 'Quantity',
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  void onAddNewContactPressed() {
    Navigator.of(context).pop();
    UserOptionsUtil.showNewContactDialog(context);
  }

  @override
  bool get wantKeepAlive => true;
}