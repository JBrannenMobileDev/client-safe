import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/pricing_profiles_page/widgets/PriceProfileListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../utils/InputDoneView.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_pricing_profile_page/DandyLightTextField.dart';

class PricePackageChangeDialog extends StatefulWidget {
  @override
  _PricePackageChangeDialogState createState() {
    return _PricePackageChangeDialogState();
  }
}

class _PricePackageChangeDialogState extends State<PricePackageChangeDialog>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final FocusNode flatRateInputFocusNode = new FocusNode();
  var flatRateTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '', thousandSeparator: ',', precision: 0);
  String oneTimePrice = '';
  OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        KeyboardVisibilityNotification().addNewListener(
            onShow: () {
              showOverlay(context);
            },
            onHide: () {
              removeOverlay();
            }
        );
        flatRateTextController.text = '\$';
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
        flatRateInputFocusNode.addListener(() {
          flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
        });
      },
      onDidChange: (previous, current) {
        if(flatRateTextController.text == '') flatRateTextController.text = '\$';
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
            child: Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: pageState.priceProfiles.length > 0
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 28.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Input a one time price \nor select a price package",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          UserOptionsUtil.showNewPriceProfileDialog(context);
                        },
                        child: Container(
                          height: 28.0,
                          width: 28.0,
                          child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPrimaryColor()),),
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 70.0,
                      maxHeight: 550.0,
                    ),
                    child: ListView.builder(
                      reverse: false,
                      padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.priceProfiles.length + 1,
                      itemBuilder: _buildItem,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Cancel',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            pageState.onSaveUpdatedPriceProfileSelected(oneTimePrice);
                            VibrateUtil.vibrateHeavy();
                            Navigator.of(context).pop();
                          },
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Save',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0, top: 16.0),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: "Select a Price Package",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.0, left: 24, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "You do not have any pricing packages setup. "
                          "Select the button below to create a new pricing package.",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  ClientSafeButton(
                    height: 48.0,
                    width: 224,
                    text: "Pricing Package",
                    marginLeft: 32.0,
                    marginTop: 0.0,
                    marginRight: 32.0,
                    marginBottom: 0.0,
                    onPressed: () {
                      UserOptionsUtil.showNewPriceProfileDialog(context);
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    urlText: "",
                      color: ColorConstants.getBlueDark()
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Cancel',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: index == 0 ? Container(
          padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
          child: Column(
            children: [
              DandyLightTextField(
                controller: flatRateTextController,
                hintText: "\$",
                inputType: TextInputType.number,
                focusNode: flatRateInputFocusNode,
                height: 66.0,
                onTextInputChanged: (input) {
                  setState(() {
                    String numbersOnly = input.replaceAll('\$', '').replaceAll(' ', '');
                    if(numbersOnly == '0') {
                      numbersOnly = '';
                    }
                    oneTimePrice = numbersOnly;
                  });
                },
                capitalization: TextCapitalization.none,
                keyboardAction: TextInputAction.done,
                labelText: 'One time price',
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "Or",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ],
          ),
        ) : PriceProfileListWidget(
            pageState.priceProfiles.elementAt(index - 1),
            pageState,
            onProfileSelected,
            pageState.selectedPriceProfile == pageState.priceProfiles.elementAt(index - 1) && isOneTimePriceEmpty(oneTimePrice)
                ? Color(ColorConstants.getBlueDark())
                : Colors.white,pageState.selectedPriceProfile == pageState.priceProfiles.elementAt(index - 1) && isOneTimePriceEmpty(oneTimePrice)
            ? Color(ColorConstants.getPrimaryWhite())
            : Color(ColorConstants.getPrimaryBlack())),
      ),
    );
  }

  onProfileSelected(PriceProfile priceProfile, var pageState, BuildContext context) {
    pageState.onPriceProfileSelected(priceProfile);
    flatRateTextController.text = '\$';
    oneTimePrice = '';
    flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
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

  bool isOneTimePriceEmpty(String oneTimePrice) {
    String numbersOnly = oneTimePrice.replaceAll('\$', '').replaceAll(' ', '');
    if(numbersOnly == '0') {
      numbersOnly = '';
    }
    return numbersOnly.isEmpty;
  }
}
